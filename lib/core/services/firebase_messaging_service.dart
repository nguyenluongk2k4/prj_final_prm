import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:prj_final_prm/core/router/app_routes.dart';
import 'package:prj_final_prm/core/router/app_router.dart';
import 'package:prj_final_prm/features/call/data/call_session_service.dart';
import 'package:prj_final_prm/features/call/presentation/models/call_args.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  final data = message.data;
  final type = data['type']?.toString().toLowerCase();
  if (type != 'call') return;

  final channelId = data['channel']?.toString().trim() ?? '';
  final callerId = data['caller_id']?.toString().trim() ?? '';
  final receiverId = data['receiver_id']?.toString().trim() ?? '';
  final callType = data['call_type']?.toString().toLowerCase() ?? 'voice';
  final callerName = data['caller_name']?.toString().trim() ?? 'Người dùng';

  if (channelId.isEmpty || callerId.isEmpty) return;

  await _showCallkit(
    uuid: const Uuid().v4(),
    channelId: channelId,
    callerId: callerId,
    receiverId: receiverId,
    callerName: callerName,
    isVideo: callType == 'video',
    callSessionId: data['call_id']?.toString().trim(),
  );
}

Future<void> _showCallkit({
  required String uuid,
  required String channelId,
  required String callerId,
  required String receiverId,
  required String callerName,
  required bool isVideo,
  String? avatarUrl,
  String? callSessionId,
}) async {
  final params = CallKitParams(
    id: uuid,
    nameCaller: callerName,
    appName: 'Heart Link',
    avatar: avatarUrl,
    handle: channelId,
    type: isVideo ? 1 : 0,
    duration: 60000,
    textAccept: 'Nghe máy',
    textDecline: 'Từ chối',
    extra: {
      'channel_id': channelId,
      'caller_id': callerId,
      'receiver_id': receiverId,
      'is_video': isVideo.toString(),
      'call_session_id': callSessionId ?? '',
    },
    android: const AndroidParams(
      isCustomNotification: true,
      isShowLogo: false,
      ringtonePath: 'incoming_call',
      backgroundColor: '#1B1B1B',
      actionColor: '#4CAF50',
      textColor: '#ffffff',
      incomingCallNotificationChannelName: 'Incoming Calls',
      missedCallNotificationChannelName: 'Missed Calls',
    ),
    ios: const IOSParams(
      iconName: 'CallKitLogo',
      handleType: 'generic',
      supportsVideo: true,
      maximumCallGroups: 1,
      maximumCallsPerCallGroup: 1,
      audioSessionMode: 'default',
      audioSessionActive: true,
      audioSessionPreferredSampleRate: 44100.0,
      audioSessionPreferredIOBufferDuration: 0.005,
      supportsDTMF: false,
      supportsHolding: false,
      supportsGrouping: false,
      supportsUngrouping: false,
      ringtonePath: 'system_ringtone_default',
    ),
  );
  await FlutterCallkitIncoming.showCallkitIncoming(params);
}

@lazySingleton
class FirebaseMessagingService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final SupabaseClient _supabase;
  StreamSubscription<AuthState>? _authSub;
  String? _activeCallChannelId; // deduplicate concurrent call notifications

  FirebaseMessagingService([SupabaseClient? supabase])
      : _supabase = supabase ?? Supabase.instance.client;

  Future<void> init() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    final token = await _messaging.getToken();
    if (kDebugMode) debugPrint('[FCM] token=$token');
    await _saveToken(token);

    _messaging.onTokenRefresh.listen((t) async => _saveToken(t));

    // Listen for callkit events (accept/decline from notification)
    FlutterCallkitIncoming.onEvent.listen(_onCallkitEvent);

    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) debugPrint('[FCM] foreground: ${message.messageId}');
      if (_isCallMessage(message)) {
        unawaited(_handleCallMessage(message));
      }
      // non-call foreground notifications handled by FCM itself
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (_isCallMessage(message)) unawaited(_handleCallMessage(message));
    });

    final initial = await _messaging.getInitialMessage();
    if (initial != null && _isCallMessage(initial)) {
      await _handleCallMessage(initial);
    }

    _authSub ??= _supabase.auth.onAuthStateChange.listen((data) async {
      if (data.session?.user == null) return;
      await _saveToken(await _messaging.getToken());
    });
  }

  void _onCallkitEvent(CallEvent? event) {
    if (event == null) return;
    final extra = event.body['extra'] as Map? ?? {};
    final channelId = extra['channel_id']?.toString() ?? '';
    final callerId = extra['caller_id']?.toString() ?? '';
    final receiverId = extra['receiver_id']?.toString() ?? '';
    final isVideo = extra['is_video']?.toString() == 'true';
    final callerName = event.body['nameCaller']?.toString() ?? 'Người dùng';
    final callSessionId = extra['call_session_id']?.toString();

    switch (event.event) {
      case Event.actionCallAccept:
        _activeCallChannelId = null;
        unawaited(CallSessionService.updateStatus(callSessionId, 'ongoing'));
        final args = CallArgs(
          channelId: channelId,
          localUserId: receiverId,
          remoteUserId: callerId,
          remoteName: callerName,
          remoteAvatarUrl: null,
          isVideo: isVideo,
          isIncoming: true,
          callSessionId: callSessionId,
        );
        Future.delayed(const Duration(milliseconds: 300), () {
          AppRouter.router.push(AppRoutes.callActive, extra: args);
        });
        break;
      case Event.actionCallDecline:
        _activeCallChannelId = null;
        unawaited(CallSessionService.updateStatus(callSessionId, 'rejected'));
        FlutterCallkitIncoming.endAllCalls();
        break;
      case Event.actionCallTimeout:
        _activeCallChannelId = null;
        unawaited(CallSessionService.updateStatus(callSessionId, 'missed'));
        FlutterCallkitIncoming.endAllCalls();
        break;
      case Event.actionCallEnded:
        _activeCallChannelId = null;
        FlutterCallkitIncoming.endAllCalls();
        break;
      default:
        break;
    }
  }

  bool _isCallMessage(RemoteMessage message) =>
      message.data['type']?.toString().toLowerCase() == 'call';

  Future<void> _handleCallMessage(RemoteMessage message) async {
    final data = message.data;
    final channelId = data['channel']?.toString().trim() ?? '';
    final callerId = data['caller_id']?.toString().trim() ?? '';
    final receiverId = data['receiver_id']?.toString().trim() ?? '';
    final callType = data['call_type']?.toString().toLowerCase() ?? 'voice';

    if (channelId.isEmpty || callerId.isEmpty) return;

    // Deduplicate — same channel already showing
    if (_activeCallChannelId == channelId) return;

    // Also check callkit active calls to avoid duplicate
    try {
      final active = await FlutterCallkitIncoming.activeCalls();
      if (active is List && active.isNotEmpty) {
        final alreadyExists = active.any((c) {
          final extra = (c as Map?)?['extra'] as Map?;
          return extra?['channel_id']?.toString() == channelId;
        });
        if (alreadyExists) return;
      }
    } catch (_) {}

    _activeCallChannelId = channelId;

    String callerName = 'Người dùng';
    String? avatarUrl;
    try {
      final profile = await _supabase
          .from('profiles')
          .select('display_name,avatar_url')
          .eq('user_id', callerId)
          .maybeSingle();
      if (profile != null) {
        final n = profile['display_name']?.toString().trim() ?? '';
        if (n.isNotEmpty) callerName = n;
        avatarUrl = profile['avatar_url']?.toString();
      }
    } catch (_) {}

    await _showCallkit(
      uuid: const Uuid().v4(),
      channelId: channelId,
      callerId: callerId,
      receiverId: receiverId,
      callerName: callerName,
      isVideo: callType == 'video',
      avatarUrl: avatarUrl,
      callSessionId: data['call_id']?.toString().trim(),
    );
  }

  Future<void> _saveToken(String? token) async {
    if (token == null || token.isEmpty) return;
    final session = _supabase.auth.currentSession;
    if (session == null) return;
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;
    try {
      await _supabase
          .from('profiles')
          .update({'fcm_token': token})
          .eq('user_id', userId);
      if (kDebugMode) debugPrint('[FCM] token saved for $userId');
    } catch (e) {
      if (kDebugMode) debugPrint('[FCM] failed to save token: $e');
    }
  }
}
