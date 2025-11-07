import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class InjuryStepper extends StatefulWidget {
  final String title;
  final List<String> steps;
  final String? imageAsset;
  const InjuryStepper({super.key, required this.title, required this.steps, this.imageAsset});

  @override
  State<InjuryStepper> createState() => _InjuryStepperState();
}

class _InjuryStepperState extends State<InjuryStepper> {
  int idx = 0;
  final FlutterTts _tts = FlutterTts();

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  Future<void> _speak() async {
    final text = "${widget.title}. Step ${idx+1}. ${widget.steps[idx]}";
    await _tts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.steps.length;
    final progress = (idx+1) / (total == 0 ? 1 : total);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.imageAsset != null) Image.asset('assets/icons/${widget.imageAsset}', height: 200, fit: BoxFit.cover),
        const SizedBox(height: 12),
        Text("Step ${idx+1} of $total", style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 6),
        LinearProgressIndicator(value: progress),
        const SizedBox(height: 12),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(widget.steps[idx], style: TextStyle(fontSize: 18)),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: idx>0 ? () => setState(() => idx--) : null,
              icon: Icon(Icons.arrow_back), label: Text("Previous")
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: _speak,
              icon: Icon(Icons.volume_up), label: Text("Play")
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: idx < total-1 ? () => setState(() => idx++) : null,
              icon: Icon(Icons.arrow_forward), label: Text("Next")
            ),
          ],
        )
      ],
    );
  }
}