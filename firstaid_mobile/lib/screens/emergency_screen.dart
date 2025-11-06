import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  // Make a phone call
  Future<void> _callNumber(String number) async {
    final Uri callUri = Uri(scheme: 'tel', path: number);

    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      // Show an error if call cannot be made
      debugPrint('Could not launch $number');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Emergency Contacts"),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Emergency instructions
            const Text(
              "If someone is seriously injured, call your local emergency number immediately.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 30),

            // Optional extra info
            Card(
              color: Colors.red[50],
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: const [
                    Text(
                      "Important Tips:",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "• Stay calm and check the scene for safety.\n"
                      "• Make sure the patient is breathing.\n"
                      "• Apply first-aid if trained.\n"
                      "• Provide the emergency operator with clear details.",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Call button
            ElevatedButton.icon(
              onPressed: () => _callNumber("911"), // Replace with local emergency number if needed
              icon: const Icon(Icons.call),
              label: const Text(
                "Call Emergency (911)",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
