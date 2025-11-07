import 'package:flutter/material.dart';
import '../services/emergency_service.dart';
import '../widgets/phone_keypad.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  Future<void> _handleCall(BuildContext context, String number) async {
    final err = await EmergencyService.tryCall(number);
    if (err != null) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Call failed'),
          content: Text(
            'We could not start a call or FaceTime to $number on this device.\n\n'
            'Please call the number manually or use another device.\n\nError: $err',
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Attempting to call $number')));
    }
  }

  @override
  Widget build(BuildContext context) {
    String lastNumber = '';

    return Scaffold(
      appBar: AppBar(title: const Text('Emergency'), backgroundColor: Colors.redAccent),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Quick Dial — enter a number or use your emergency contact',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                child: PhoneKeypad(
                  initialNumber: '',
                  callLabel: 'Call',
                  onChanged: (n) => lastNumber = n,
                  onCall: (n) async {
                    await _handleCall(context, n);
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await _handleCall(context, '112'); 
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                    child: const Text('Call 112'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      await _handleCall(context, '911');
                    },
                    child: const Text('My Contact'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
