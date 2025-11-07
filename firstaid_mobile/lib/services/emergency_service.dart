import 'package:url_launcher/url_launcher.dart';

class EmergencyService {
  static Future<void> call(String number) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: number);

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
      return;
    }

    final Uri facetimeUri = Uri(scheme: 'facetime', path: number);
    if (await canLaunchUrl(facetimeUri)) {
      await launchUrl(facetimeUri);
      return;
    }

    throw Exception('Device cannot place a phone call or FaceTime to $number');
  }

  static Future<String?> tryCall(String number) async {
    try {
      await call(number);
      return null; // null = success
    } catch (e) {
      return e.toString();
    }
  }
}
