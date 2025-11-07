import 'package:flutter/material.dart';
import '../services/profile_service.dart';

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
    
    setState(() => _loading = false);
  }

  Future<void> _save() async {
    final profile = Profile(
      name: _nameController.text.trim(),
      bloodType: _bloodController.text.trim(),
      allergies: _allergyController.text.trim(),
      emergencyContact: _emergencyController.text.trim(),
    );
    await ProfileService.save(profile);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile saved')),
    );
    Navigator.pop(context);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: _loading 
      ? const Center(child: CircularProgressIndicator())
      : Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              "Your details help in emergencies.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _bloodController,
              decoration: const InputDecoration(
                labelText: 'Blood Type (e.g. 0+)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _allergyController,
              decoration: const InputDecoration(
                labelText: 'Allergies',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emergencyController,
              decoration: const InputDecoration(
                labelText: 'Emergency Contact Number',
                hintText: 'e.g. +44 7xx xxxxxx',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ) ,
              child: const Text(
                'Save',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),

              )
            )
          ],
        ),

      )
    );
  }
}