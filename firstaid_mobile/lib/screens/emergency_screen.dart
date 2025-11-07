import 'package:flutter/material.dart';
import '../services/emergency_service.dart';
import '../widgets/phone_keypad.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  String? _emergencyNumber;
  String? _manualNumber = '';
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _resolveEmergencyNumber();
  }

  Future<void> _resolveEmergencyNumber() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Location services are disabled.';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permission denied.';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Location permission permanently denied.';
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );

      final placemarks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
      final countryCode = placemarks.isNotEmpty ? (placemarks.first.isoCountryCode ?? '').toUpperCase() : '';
      final number = _numberForCountry(countryCode);

      setState(() {
        _emergencyNumber = number;
        _loading = false;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _emergencyNumber = '999';
        _loading = false;
        _error = e.toString();
      });
    }
  }

  String _numberForCountry(String code) {
    switch (code) {
      case 'US':
      case 'CA':
        return '911';
      case 'GB':
        return '999';
      case 'AU':
        return '000';
      case 'NZ':
        return '111';
      default:
        return '112';
    }
  }

  Future<void> _handleCall(BuildContext context, String number) async {
    final err = await EmergencyService.tryCall(number);
    if (err != null && mounted) {
      await showDialog(
        context: context, 
        builder: (ctx) => AlertDialog(
          title: const Text('Call failed'),
          content: Text(
            'We could not start a call to this $number on this device.\n\n'
            'Please dial the number manually or use another device.\n\nError: $err',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx), 
              child: const Text('OK'),
            )
          ],
        )
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Attempting to call $number')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final numberLabel = _emergencyNumber ?? '...';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency'), 
        backgroundColor: Colors.redAccent
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'If someone is seriously injured, call your local emergency number immediately.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),

            if (_loading)
              const Padding(
                padding: EdgeInsets.all(18),
                child: CircularProgressIndicator(),
              )
              else if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'Could not auto detect your region.\nUsing default emergency number: $numberLabel',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, color: Colors.redAccent),
                ),
              ),

            Card(
              color: Colors.red[50],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16),
              ),
              child: const Padding (
                padding: EdgeInsets.all(6),
                child: Text(
                  "Important Tips:\n\n"
                  "• Stay calm and check the scene for safety.\n"
                  "• Ensure the person is breathing.\n"
                  "• Apply first-aid if trained.\n"
                  "• Give clear details to the emergency operator.",
                  style: TextStyle(fontSize: 14, height: 1.4),
                ),
              ),
            ),
       
            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: _loading ? null : () => _handleCall(context, _emergencyNumber ?? '999'), 
              icon: const Icon(Icons.local_phone, size: 16),
              label: Text(
                _loading ? "Detecting emergency number..." : "$numberLabel",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 8),

            const Align(
              alignment: AlignmentGeometry.centerLeft,
              child: Text(
                "Or dial another number:",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: SingleChildScrollView(
                child: PhoneKeypad(
                  initialNumber: _manualNumber ?? '',
                  callLabel: 'Call',
                  onChanged: (n) {
                    _manualNumber = n;
                  },
                  onCall: (n) async {
                    await _handleCall(context, n);
                  },
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}

