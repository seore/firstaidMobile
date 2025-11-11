import 'package:flutter/material.dart';
import '../services/mode_service.dart';
import 'home_screen.dart';
import 'emergency_screen.dart';

class ModeSelectionScreen extends StatelessWidget {
  const ModeSelectionScreen({super.key});

  Future<void> _selectEmergency(BuildContext context) async {
    await ModeService.saveMode('emergency');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const EmergencyScreen()),
    );
  }

   Future<void> _selectLearn(BuildContext context) async {
    await ModeService.saveMode('learning');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/icons/appIconT.png', height: 120),
              const SizedBox(height: 30),
              const Text(
                "Choose Your Mode",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),

              // Emergency Mode
              ElevatedButton.icon(
                onPressed: () => _selectEmergency(context),
                icon: const Icon(Icons.flash_on, color: Colors.white),
                label: const Text('Emergency Mode'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 247, 23, 23),
                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(16)),
                ),
              ),
              const SizedBox(height: 20),

              // Learning Mode
              OutlinedButton.icon(
                onPressed: () => _selectLearn(context), 
                icon: const Icon(Icons.book, color: Colors.blue),
                label: const Text(
                  "Learning Mode",
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.blue, width: 2), 
                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () async {
                  await ModeService.clearMode();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Mode preference reset.')),
                  );
                },
                child: const Text('Reset choice'),
              )
            ],
          ),
        ),
      ),
    );
  }
}