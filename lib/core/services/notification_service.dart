import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Service managing local notifications and reminder triggers.
class NotificationService {
  NotificationService._();

  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidInitialization =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinInitialization = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initializationSettings = InitializationSettings(
      android: androidInitialization,
      iOS: darwinInitialization,
      macOS: darwinInitialization,
    );

    try {
      await _notificationsPlugin.initialize(initializationSettings);
    } catch (_) {
      // Gracefully handle platform notification init when running on web or unconfigured environments
    }
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'lankapulse_channel_id',
      'LankaPulse Notifications',
      channelDescription: 'LankaPulse Reminders and Emergency Alerts',
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    try {
      await _notificationsPlugin.show(
        id,
        title,
        body,
        notificationDetails,
        payload: payload,
      );
    } catch (_) {}
  }
}
