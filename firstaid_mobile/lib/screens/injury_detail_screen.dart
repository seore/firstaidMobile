import 'package:flutter/material.dart';
import '../models/injury.dart';
import '../widgets/injury_stepper.dart';

class InjuryDetailScreen extends StatelessWidget {
  final Injury injury;
  //const InjuryDetailScreen({required this.injury, super.key});
  const InjuryDetailScreen({super.key, required this.injury});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(injury.name),
        backgroundColor: Colors.blueAccent,
        elevation: 3,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: InjuryStepper(
          title: injury.name, 
          steps: injury.steps,
          imageAsset: injury.imageName,
        ),
      )
    );
  }
}

