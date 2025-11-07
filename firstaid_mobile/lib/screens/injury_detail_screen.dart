import 'package:flutter/material.dart';
import '../models/injury.dart';
import '../widgets/injury_stepper.dart';
import '../services/emergency_service.dart';

class InjuryDetailScreen extends StatelessWidget {
  final Injury injury;
  //const InjuryDetailScreen({required this.injury, super.key});
  const InjuryDetailScreen({super.key, required this.injury});

  @override
  Widget build(BuildContext context) {
    Future<void> _handleEmergencyCall() async {
      const fallbackNumber = '112';
      final err = await EmergencyService.tryCall(fallbackNumber);

      if (err != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Could not start an emergency call.'
              'Please dial $fallbackNumber manaually.\nError: $err',
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Attempting emergency call...'))
        );
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(injury.name),
        backgroundColor: Colors.blueAccent,
        elevation: 3,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: InjuryStepper(
                title: injury.name, 
                steps: injury.steps,
                imageAsset: injury.imageName,
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _handleEmergencyCall,
                icon: const Icon(Icons.local_phone),
                label: const Text(
                  'Emergency Call',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  )
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}

