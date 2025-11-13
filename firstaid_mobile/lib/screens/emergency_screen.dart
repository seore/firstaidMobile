import 'package:flutter/material.dart';
import '../services/emergency_service.dart';
import '../services/profile_service.dart';
import '../widgets/phone_keypad.dart';
import '../models/profile.dart';
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

  Profile? _profile;
  bool _profileLoading = true;

  String? _countryName;
  String? _locality;
  String? _countryCode;

  @override
  void initState() {
    super.initState();
    _resolveEmergencyNumber();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await ProfileService.load();
    setState(() {
      _profile = profile;
      _profileLoading = false;
    });
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
      final place = placemarks.isNotEmpty ? placemarks.first : null;
      final countryCode = place?.isoCountryCode != null ? place!.isoCountryCode!.toUpperCase() : '';
      final countryName = place?.country;
      final locality = place?.locality ?? place?.subAdministrativeArea;
      final number = _numberForCountry(countryCode);

      if (!mounted) return;
      setState(() {
        _emergencyNumber = number;
        _countryCode = countryCode;
        _countryName = countryName;
        _locality = locality;
        _loading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _emergencyNumber = '999';
        _loading = false;
        _error = 'We couldn’t automatically detect your location. Using a default emergency number. Please double-check your local number.';
      });
    }
  }

  String _numberForCountry(String code) {
  switch (code) {
    // North America
    case 'US':
    case 'CA':
      return '911';
    case 'MX': // Mexico
      return '911';

    // UK & Europe
    case 'GB': // United Kingdom
      return '999';
    case 'IE': // Ireland
      return '112';
    case 'FR': // France
    case 'DE': // Germany
    case 'ES': // Spain
    case 'IT': // Italy
    case 'NL': // Netherlands
    case 'BE': // Belgium
    case 'PT': // Portugal
    case 'SE': // Sweden
    case 'FI': // Finland
    case 'NO': // Norway
    case 'DK': // Denmark
    case 'PL': // Poland
    case 'CZ': // Czech Republic
    case 'GR': // Greece
      return '112';

    // Oceania
    case 'AU': // Australia
      return '000';
    case 'NZ': // New Zealand
      return '111';
    case 'PG': // Papua New Guinea
      return '111';
    case 'FJ': // Fiji
      return '911';

    // Asia
    case 'IN': // India
      return '112';
    case 'CN': // China
      return '120';
    case 'JP': // Japan
      return '119';
    case 'KR': // South Korea
      return '119';
    case 'SG': // Singapore
      return '995';
    case 'MY': // Malaysia
      return '999';
    case 'TH': // Thailand
      return '1669';
    case 'PH': // Philippines
      return '911';
    case 'ID': // Indonesia
      return '118';

    // Middle East
    case 'AE': // United Arab Emirates
      return '998';
    case 'SA': // Saudi Arabia
      return '997';
    case 'IL': // Israel
      return '101';
    case 'QA': // Qatar
      return '999';
    case 'KW': // Kuwait
      return '112';
    case 'OM': // Oman
      return '9999';
    case 'BH': // Bahrain
      return '999';

    // Africa
    case 'ZA': // South Africa
      return '112';
    case 'NG': // Nigeria
      return '112';
    case 'GH': // Ghana
      return '112';
    case 'KE': // Kenya
      return '999';
    case 'EG': // Egypt
      return '123';
    case 'MA': // Morocco
      return '190';
    case 'ET': // Ethiopia
      return '907';
    case 'TZ': // Tanzania
      return '112';
    case 'UG': // Uganda
      return '999';

    // South America
    case 'BR': // Brazil
      return '190';
    case 'AR': // Argentina
      return '911';
    case 'CL': // Chile
      return '131';
    case 'CO': // Colombia
      return '123';
    case 'PE': // Peru
      return '105';
    case 'VE': // Venezuela
      return '171';

    default:
      return '112'; // universal GSM emergency number
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
    final myContact = _profile?.emergencyContact.trim() ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency'), 
        backgroundColor: const Color.fromARGB(255, 223, 2, 2),
        actions: [
          IconButton(
            tooltip: 'Injuries',
            icon: const Icon(Icons.medical_services),
            onPressed: () async {
              await Navigator.pushNamed(context, '/home');
              await _loadProfile();
            },
          ),
          IconButton(
            tooltip: 'Profile',
            icon: const Icon(Icons.person),
            onPressed: () async {
              await Navigator.pushNamed(context, '/profile');
              await _loadProfile();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.emergency_share, size: 48, color: Color.fromARGB(255, 223, 2, 2)
            ),
            const SizedBox(height: 15),
            const Text(
              'If someone is seriously injured, please call your local emergency number immediately.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),

            // Location Info
            if (_countryName != null || _locality != null) ...[
              Text(
                'Detected Location: '
                '${_locality ?? ''}${_locality != null && _countryCode != null ? ', ' : ''}'
                '${_countryName ?? ''}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 8),
            ],

            // Error if permission denied
            if (_error != null) ...[
              Text(
                'Location issue: $_error\nUsing a different emergency number. Please double check your local number.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.redAccent),
              ),
              const SizedBox(height: 8),
            ],
            
            Card(
              color: Colors.red[50],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16),
              ),
              child: const Padding (
                padding: EdgeInsets.all(15),
                child: Text(
                  "Important Tips:\n"
                  "• Stay calm and check the scene for safety.\n"
                  "• Ensure the person is breathing.\n"
                  "• Apply first-aid if trained.\n"
                  "• Give clear details to the emergency operator.",
                  style: TextStyle(fontSize: 14, height: 1.5),
                ),
              ),
            ),
       
            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: _loading ? null : () => _handleCall(context, _emergencyNumber ?? '112'), 
              //icon: const Icon(Icons.local_phone, size: 14),
              label: Text(
                _loading ? "Detecting emergency number..." : "Call $numberLabel",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 223, 2, 2),
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _profileLoading ? null : () async {
                  if (myContact.isEmpty) {
                    await Navigator.pushNamed(context, '/profile');
                    await _loadProfile();
                  } else {
                    await _handleCall(context, myContact);
                  }
                }, 
                icon: const Icon(Icons.contact_phone, color: Color.fromARGB(255, 223, 2, 2)),
                label: Text(
                  _profileLoading ? 'Loading Contact...' : (myContact.isEmpty ? 'Set Emergency Contact' : 'Call Emergency Contact $myContact'),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 223, 2, 2),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color.fromARGB(255, 223, 2, 2), width: 2),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(12)
                ),
              ),
            ),
          ),
      
          const SizedBox(height: 8),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Card(
                    color: Colors.red[50],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: const Padding(
                      padding: EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "When you call be ready to say:",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          SizedBox(height: 6),
                          Text("Where are you (address or landmark)?"),
                          Text("What happened (e.g. burn, fall, choking)?"),
                          Text("How many people are injured?"),
                          Text("If the person is awake and breathing."),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          
          /*
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
          */
        ],
      ),
    ),
  );
  }
}

