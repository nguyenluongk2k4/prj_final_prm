import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:prj_final_prm/core/utils/notification_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (kDebugMode) {
    debugPrint('[FCM] background message: ${message.messageId}');
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

    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        debugPrint('[FCM] foreground message: ${message.messageId}');
      }
      NotificationService.showForegroundNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (kDebugMode) {
        debugPrint('[FCM] opened message: ${message.messageId}');
      }
    });

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
}
