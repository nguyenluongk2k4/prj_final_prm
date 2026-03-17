import 'dart:typed_data';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel =
      AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'Used for important notifications.',
    importance: Importance.high,
  );

  static final AndroidNotificationChannel _callChannel =
      AndroidNotificationChannel(
    'call_channel',
    'Incoming Calls',
    description: 'Used for incoming call notifications.',
    importance: Importance.max,
    sound: const RawResourceAndroidNotificationSound('incoming_call'),
    playSound: true,
    enableVibration: true,
    vibrationPattern: Int64List.fromList([0, 1000, 500, 1000, 500, 1000]),
  );

  static void Function(String payload)? _onTap;

  static void setOnNotificationTap(void Function(String payload) callback) {
    _onTap = callback;
  }

  static Future<void> init() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    final initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload != null && _onTap != null) {
          _onTap!(payload);
        }
      },
    );

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(_channel);
    await androidPlugin?.createNotificationChannel(_callChannel);
  }

  static Future<NotificationAppLaunchDetails?> getLaunchDetails() {
    return _plugin.getNotificationAppLaunchDetails();
  }

  /// Show full-screen incoming call notification — wakes screen, plays ringtone
  static Future<void> showIncomingCallNotification({
    required String callerName,
    required String channelId,
    required String callerId,
    required String receiverId,
    required bool isVideo,
  }) async {
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _callChannel.id,
        _callChannel.name,
        channelDescription: _callChannel.description,
        importance: Importance.max,
        priority: Priority.max,
        fullScreenIntent: true,
        category: AndroidNotificationCategory.call,
        ongoing: true,
        autoCancel: false,
        icon: '@mipmap/ic_launcher',
        sound: const RawResourceAndroidNotificationSound('incoming_call'),
        playSound: true,
        enableVibration: true,
        vibrationPattern: Int64List.fromList([0, 1000, 500, 1000, 500, 1000]),
        additionalFlags: Int32List.fromList([4]),
      ),
    );

    await _plugin.show(
      999,
      isVideo ? '📹 Cuộc gọi video đến' : '📞 Cuộc gọi thoại đến',
      callerName,
      details,
      payload:
          'call|$channelId|$callerId|$receiverId|${isVideo ? 'video' : 'voice'}',
    );
  }

  static Future<void> cancelCallNotification() async {
    await _plugin.cancel(999);
  }

  static Future<void> showForegroundNotification(RemoteMessage message) async {
    final notification = message.notification;
    final android = notification?.android;
    final title = notification?.title ?? message.data['title']?.toString();
    final body = notification?.body ?? message.data['body']?.toString();

    if (title == null && body == null) return;

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channel.id,
        _channel.name,
        channelDescription: _channel.description,
        importance: Importance.high,
        priority: Priority.high,
        icon: android?.smallIcon,
      ),
    );

    await _plugin.show(message.hashCode, title, body, details);
  }

  static Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  static Future<bool> checkNotificationPermission() async {
    final status = await Permission.notification.status;
    return status.isGranted;
  }
}
