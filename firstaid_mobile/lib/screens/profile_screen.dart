import 'package:flutter/material.dart';
import '../services/profile_service.dart';
import '../models/profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _bloodController = TextEditingController();
  final _allergyController = TextEditingController();
  final _emergencyController = TextEditingController();

  bool _loading = true;

  String _lastUpdated = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await ProfileService.load();
    _nameController.text = profile.name;
    _bloodController.text = profile.bloodType;
    _allergyController.text = profile.allergies;
    _emergencyController.text = profile.emergencyContact;
    _lastUpdated = profile.lastUpdated;

    if (!mounted) return;
    setState(() => _loading = false);
  }

  Future<void> _save() async {
    final now = DateTime.now();
    final formatted = "${now.day} ${_monthName(now.month)} ${now.year}";
    
    final profile = Profile(
      name: _nameController.text.trim(),
      bloodType: _bloodController.text.trim(),
      allergies: _allergyController.text.trim(),
      emergencyContact: _emergencyController.text.trim(),
      lastUpdated: formatted,
    );
    
    await ProfileService.save(profile);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile saved')),
    );
    
    Navigator.pop(context);
  }

  String _monthName(int m) {
    const months = [
      "", "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return months[m];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bloodController.dispose();
    _allergyController.dispose();
    _emergencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            tooltip: 'Emergency Call',
            icon: const Icon(Icons.phone, color: Color.fromARGB(255, 237, 17, 2),),
            onPressed: () async {
              await Navigator.pushNamed(context, '/dialer');
              await _loadProfile();
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : GestureDetector(
              // dismiss keyboard on tap background
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Avatar card
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor:
                                  const Color.fromARGB(255, 0, 0, 0),
                              child: Text(
                                (_nameController.text.isNotEmpty
                                        ? _nameController.text[0]
                                        : 'A')
                                    .toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _nameController.text.isEmpty
                                        ? 'Add your name'
                                        : _nameController.text,
                                    style: theme.textTheme.titleLarge
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'In Case of Emergency (ICE) details',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.red.shade50,
                              ),
                              child: const Text(
                                'ICE',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      "Your details help responders make safer, faster decisions in an emergency.",
                      style: const TextStyle(fontSize: 14, height: 1.4),
                    ),
                    const SizedBox(height: 16),

                    // Medical info section
                    Text(
                      'Medical Info',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: _bloodController,
                      decoration: const InputDecoration(
                        labelText: 'Blood Type',
                        hintText: 'e.g. O+, A-, B+',
                        prefixIcon: Icon(Icons.bloodtype),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: _allergyController,
                      decoration: const InputDecoration(
                        labelText: 'Medical Conditions',
                        hintText: 'e.g. peanuts, penicillin',
                        prefixIcon: Icon(Icons.warning_amber_rounded),
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),

                    const SizedBox(height: 20),

                    // Emergency contact section
                    Text(
                      'Emergency Contact',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    TextField(
                      controller: _emergencyController,
                      decoration: const InputDecoration(
                        labelText: 'Contact Number',
                        hintText: 'e.g. +44 7xx xxxxxx',
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                    ),

                    const SizedBox(height: 20),

                    // ICE preview card
                    Card(
                      color: Colors.grey.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.health_and_safety,
                                color: Colors.redAccent),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'ICE Summary',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    [
                                      if (_bloodController.text.isNotEmpty)
                                        'Blood: ${_bloodController.text}',
                                      if (_allergyController.text.isNotEmpty)
                                        'Allergies: ${_allergyController.text}',
                                      if (_emergencyController
                                          .text.isNotEmpty)
                                        'Contact: ${_emergencyController.text}',
                                    ].join('\n'),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black87,
                                      height: 1.3,
                                    ),
                                  ),
                                  if (_bloodController.text.isEmpty &&
                                      _allergyController.text.isEmpty &&
                                      _emergencyController.text.isEmpty)
                                    const Text(
                                      'Fill in your details above to see a quick emergency summary here.',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black54,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Save button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _save,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Save Profile',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    if (_lastUpdated.isNotEmpty) ...[
  const SizedBox(height: 20),
  Text(
    "Last updated: $_lastUpdated",
    textAlign: TextAlign.center,
    style: const TextStyle(
      fontSize: 14,
      color: Colors.grey,
      fontStyle: FontStyle.italic,
    ),
  ),
]
                  ],
                ),
              ),
            ),
    );
  }
}
