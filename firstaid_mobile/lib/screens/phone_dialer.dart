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
  String _number = '';

  Future<void> _handleCall(BuildContext context, String number) async {
    if (number.trim().isEmpty) return;

    HapticFeedback.heavyImpact();
    final err = await EmergencyService.tryCall(number);

    if (err != null && mounted) {
      await showDialog(
        context: context, 
        builder: (ctx) => AlertDialog(
          title: const Text('Call Failed'),
          content: Text(
            'We could not start a call to $number on this device.\n\n'
            'Please dial the number manually or use another device.\n\nError: $err',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx), 
              child: const Text('OK'),
            )
          ],
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Attempting to call $number'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dial a Phone Number'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Text(
              _number.isEmpty ? 'Enter a Phone number' : _number,
              style: const TextStyle(
                fontSize: 24, fontWeight: FontWeight.w600
              ),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: SingleChildScrollView(
                child: PhoneKeypad(
                  initialNumber: _number,
                  callLabel: 'Call',
                  onChanged: (n) {
                    setState(() {
                      _number = n;
                    });
                  },
                  onCall: (n) async {
                    await _handleCall(context, n);
                  },
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}