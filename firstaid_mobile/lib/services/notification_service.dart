import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: android, iOS: iOS);

    await _plugin.initialize(initSettings);
  }

  static Future<void> showDailyTipNotification() async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_tip_channel',
        'Daily Tips',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _plugin.show(
      0,
      'Aidly tip',
      'Practice one first-aid step today.',
      details,
    );
  }
}
