import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class InjuryStepper extends StatefulWidget {
  final String title;
  // Each step is a map: { "text": "...", "image": "steps/..." }
  final List<Map<String, dynamic>> steps;
  final String? imageAsset;

  const InjuryStepper({
    super.key,
    required this.title,
    required this.steps,
    this.imageAsset,
  });

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

  String get _currentStepText {
    final step = widget.steps[idx];
    final text = step['text'];
    if (text is String && text.isNotEmpty) {
      return text;
    }
    return '';
  }

  String? get _currentStepImage {
    final step = widget.steps[idx];
    final img = step['imageName'];
    if (img is String && img.trim().isNotEmpty) {
      return img.trim();
    }
    return null;
  }

  Future<void> _speak() async {
    final text = "Step ${idx + 1}. $_currentStepText";
    await _tts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.steps.length;
    final progress = (idx + 1) / (total == 0 ? 1 : total);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_currentStepImage != null) ...[
          Image.asset(
            'assets/steps/${_currentStepImage!}',
            height: 400,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 12),
        ],

        Text(
          "Step ${idx + 1} of $total",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 6),

        LinearProgressIndicator(value: progress),
        const SizedBox(height: 12),

        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              _currentStepText,
              style: const TextStyle(fontSize: 18, height: 1.4),
            ),
          ),
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            ElevatedButton.icon(
              onPressed: idx > 0 ? () => setState(() => idx--) : null,
              icon: const Icon(Icons.arrow_back),
              label: const Text("Previous"),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: _speak,
              icon: const Icon(Icons.volume_up),
              label: const Text("Play"),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed:
                  idx < total - 1 ? () => setState(() => idx++) : null,
              icon: const Icon(Icons.arrow_forward),
              label: const Text("Next"),
            ),
          ],
        ),
      ],
    );
  }
}
