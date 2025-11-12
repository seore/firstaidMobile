import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/phone_keypad.dart';
import '../services/emergency_service.dart';

class PhoneDialerScreen extends StatefulWidget {
  const PhoneDialerScreen({super.key});

  @override
  State<PhoneDialerScreen> createState() => _PhoneDialerScreenState();
}

class _PhoneDialerScreenState extends State<PhoneDialerScreen> {
  String _currentNumber = '';

  Future<void> _handleCall(String number) async {
    final trimmed = number.trim();
    if (trimmed.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a number to call.')),
      );
      return;
    }

    // light haptic
    HapticFeedback.mediumImpact();

    final err = await EmergencyService.tryCall(trimmed);
    if (!mounted) return;

    if (err != null) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Call failed'),
          content: Text(
            'We could not start a call to $trimmed on this device.\n\n'
            'Please dial the number manually or use another device.\n\n'
            'Error: $err',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Attempting to call $trimmed…')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Dial Pad'),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            Text(
              'Use this dial pad to call emergency services or any important number.',
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Small hint
            const Text(
              'Tip: Save your local emergency number in your device as a contact too.',
              style: TextStyle(fontSize: 12, color: Colors.black54),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            // Phone Keypad
            Expanded(
              child: SingleChildScrollView(
                child: PhoneKeypad(
                  initialNumber: _currentNumber,
                  callLabel: 'Call',
                  onChanged: (n) {
                    setState(() {
                      _currentNumber = n;
                    });
                  },
                  onCall: (n) async {
                    await _handleCall(n);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
