import 'package:flutter/material.dart';
import '../models/injury.dart';
import '../widgets/injury_stepper.dart';
import '../services/emergency_service.dart';
import 'emergency_screen.dart';

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
        backgroundColor: const Color.fromARGB(255, 216, 216, 216),
        elevation: 3,
        actions: [
          IconButton(
            icon: const Icon(Icons.call, color: Color.fromARGB(255, 233, 0, 0)),
            tooltip: 'Emergency',
            onPressed: () => Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => EmergencyScreen()),
            )
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: InjuryStepper(
                title: injury.name, 
                steps: injury.steps.cast<Map<String, dynamic>>(),
                imageAsset: injury.imageName,
              ),
            ),

            const SizedBox(height: 12),
          ],
        )
      ),
    );
  }
}

