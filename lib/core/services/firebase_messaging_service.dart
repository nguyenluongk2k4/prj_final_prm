import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:prj_final_prm/core/utils/notification_service.dart';
import 'package:prj_final_prm/core/router/app_routes.dart';
import 'package:prj_final_prm/core/router/app_router.dart';
import 'package:prj_final_prm/features/call/presentation/models/call_args.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (kDebugMode) {
    debugPrint('[FCM] background message: ${message.messageId}');
  }

  // Show full-screen call notification when app is killed/background
  if (message.data['type']?.toString().toLowerCase() == 'call') {
    final data = message.data;
    final channelId = data['channel']?.toString().trim() ?? '';
    final callerId = data['caller_id']?.toString().trim() ?? '';
    final receiverId = data['receiver_id']?.toString().trim() ?? '';
    final callType = data['call_type']?.toString().trim().toLowerCase() ?? 'voice';
    final callerName = data['caller_name']?.toString().trim() ?? 'Người dùng';

    if (channelId.isNotEmpty && callerId.isNotEmpty) {
      await NotificationService.init();
      await NotificationService.showIncomingCallNotification(
        callerName: callerName,
        channelId: channelId,
        callerId: callerId,
        receiverId: receiverId,
        isVideo: callType == 'video',
      );
    }
  }
}

@lazySingleton
class FirebaseMessagingService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final SupabaseClient _supabase;
  StreamSubscription<AuthState>? _authSub;

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
    if (kDebugMode) {
      debugPrint('[FCM] token=$token');
    }
    await _saveToken(token);

    _messaging.onTokenRefresh.listen((newToken) async {
      if (kDebugMode) {
        debugPrint('[FCM] token refreshed');
      }
      await _saveToken(newToken);
    });

    // Handle notification tap when app is in background (not killed)
    NotificationService.setOnNotificationTap(_handleLocalNotificationTap);

    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        debugPrint('[FCM] foreground message: ${message.messageId}');
      }
      if (_isCallMessage(message)) {
        unawaited(_handleCallMessage(message));
        return;
      }
      NotificationService.showForegroundNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (kDebugMode) {
        debugPrint('[FCM] opened message: ${message.messageId}');
      }
      if (_isCallMessage(message)) {
        unawaited(_handleCallMessage(message));
      }
    });

    // App launched from killed state via notification tap
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null && _isCallMessage(initialMessage)) {
      await _handleCallMessage(initialMessage);
    }

    // Check if app was opened by tapping local call notification
    final launchDetails = await NotificationService.getLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp == true) {
      final payload = launchDetails?.notificationResponse?.payload;
      if (payload != null) {
        _handleLocalNotificationTap(payload);
      }
    }

    _authSub ??= _supabase.auth.onAuthStateChange.listen((data) async {
      if (data.session?.user == null) return;
      final freshToken = await _messaging.getToken();
      await _saveToken(freshToken);
    });
  }

  Future<void> _saveToken(String? token) async {
    if (token == null || token.isEmpty) return;
    final session = _supabase.auth.currentSession;
    if (session == null) return;
    final expiresAt = session.expiresAt;
    if (expiresAt != null) {
      final nowSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      if (nowSeconds >= expiresAt) {
        try {
          await _supabase.auth.refreshSession();
        } catch (e) {
          if (kDebugMode) {
            debugPrint('[FCM] failed to refresh session: $e');
          }
          return;
        }
      }
    }

    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;
    try {
      final response = await _supabase
          .from('profiles')
          .update({'fcm_token': token})
          .eq('user_id', userId)
          .select('user_id,fcm_token');
      if (kDebugMode) {
        debugPrint('[FCM] token saved for $userId: $response');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[FCM] failed to save token: $e');
      }
    }
  }

  void _handleLocalNotificationTap(String payload) {
    // payload format: "call|channelId|callerId|receiverId|voice/video"
    final parts = payload.split('|');
    if (parts.length < 5 || parts[0] != 'call') return;

    final channelId = parts[1];
    final callerId = parts[2];
    final receiverId = parts[3];
    final isVideo = parts[4] == 'video';

    NotificationService.cancelCallNotification();

    final args = CallArgs(
      channelId: channelId,
      localUserId: receiverId,
      remoteUserId: callerId,
      remoteName: 'Người dùng',
      remoteAvatarUrl: null,
      isVideo: isVideo,
      isIncoming: true,
    );

    AppRouter.router.push(AppRoutes.callIncoming, extra: args);
  }

  bool _isCallMessage(RemoteMessage message) {
    final type = message.data['type']?.toString().toLowerCase();
    return type == 'call';
  }

  Future<void> _handleCallMessage(RemoteMessage message) async {
    final data = message.data;
    final channelId = data['channel']?.toString().trim() ?? '';
    final callerId = data['caller_id']?.toString().trim() ?? '';
    final receiverId = data['receiver_id']?.toString().trim() ?? '';
    final callType = data['call_type']?.toString().trim().toLowerCase() ?? 'voice';

    if (channelId.isEmpty || callerId.isEmpty || receiverId.isEmpty) {
      if (kDebugMode) {
        debugPrint('[FCM] missing call payload fields');
      }
      return;
    }

    String remoteName = 'Người dùng';
    String? remoteAvatarUrl;
    try {
      final profile = await _supabase
          .from('profiles')
          .select('display_name,avatar_url')
          .eq('user_id', callerId)
          .maybeSingle();
      if (profile != null) {
        final name = profile['display_name']?.toString().trim() ?? '';
        if (name.isNotEmpty) remoteName = name;
        remoteAvatarUrl = profile['avatar_url']?.toString();
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[FCM] failed to load caller profile: $e');
      }
    }

    final args = CallArgs(
      channelId: channelId,
      localUserId: receiverId,
      remoteUserId: callerId,
      remoteName: remoteName,
      remoteAvatarUrl: remoteAvatarUrl,
      isVideo: callType == 'video',
      isIncoming: true,
    );

    AppRouter.router.push(AppRoutes.callIncoming, extra: args);
  }
}
