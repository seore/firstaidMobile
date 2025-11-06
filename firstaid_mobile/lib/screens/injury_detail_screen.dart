import 'package:flutter/material.dart';
import '../models/injury.dart';

class InjuryDetailScreen extends StatelessWidget {
  final Injury injury;
  const InjuryDetailScreen({required this.injury});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(injury.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/images/${injury.name.toLowerCase()}.png', height: 180),
            const SizedBox(height: 20),
            Text(
              "First-Aid Steps:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...injury.steps.map((s) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text("• $s", style: const TextStyle(fontSize: 16)),
                )),
          ],
        ),
      ),
    );
  }
}
