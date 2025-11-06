import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: const Text(
          "FirstAid Pocket helps you quickly find step-by-step first aid instructions even offline. "
          "It’s designed for simplicity, accessibility, and emergency readiness.",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
