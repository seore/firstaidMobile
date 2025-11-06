import 'package:flutter/material.dart';
import '../models/injury.dart';

class InjuryDetailScreen extends StatefulWidget {
  final Injury injury;
  //const InjuryDetailScreen({required this.injury, super.key});
  const InjuryDetailScreen({Key? key, required this.injury}) : super(key: key);


  @override
  _InjuryDetailScreenState createState() => _InjuryDetailScreenState();
}

class _InjuryDetailScreenState extends State<InjuryDetailScreen> {
  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    final step = widget.injury.steps[currentStep];

    return Scaffold(
      appBar: AppBar(title: Text(widget.injury.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/icons/${widget.injury.imageName}', height: 180),
            const SizedBox(height: 20),
            Text(
              "Step ${currentStep + 1}:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(step, style: const TextStyle(fontSize: 16)),
            const Spacer(),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (currentStep < widget.injury.steps.length - 1) {
                    currentStep++;
                  } else {
                    currentStep = 0;
                  }
                });
              },
              child: Text (
                currentStep < widget.injury.steps.length - 1 ? "Next Step" : "Restart Steps",
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24)
              )
            )
          ],
        ),
      ),
    );
  }
}
