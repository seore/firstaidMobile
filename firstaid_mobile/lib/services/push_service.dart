import 'package:firebase_messaging/firebase_messaging.dart';

class PushService {
  static final _messaging = FirebaseMessaging.instance;

  static Future<void> init() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((message) {
      // you can show a local notification or snackbar here
    });

    // handle when app opened from a notification etc. (optional)
  }
}
