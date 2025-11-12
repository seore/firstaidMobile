import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';

class InjuryStepper extends StatefulWidget {
  final String title;
  final List<dynamic> steps;
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
  Timer? _timer;
  int? _remainingSeconds;

  @override
  void initState(){
    super.initState();
    _setupTimer();
  }

  // New Injury steps
  @override
  void didUpdateWidget(covariant InjuryStepper old) {
    super.didUpdateWidget(old);
    if (old.steps != widget.steps) {
      idx = 0;
      _setupTimer();
    }
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  bool get _hasSteps => widget.steps.isNotEmpty;

  Map<String, dynamic> get _currentStep {
    if (!_hasSteps) return const {};
    return widget.steps[idx];
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

  int? get _currentStepTimer {
    final t = _currentStep['timerSeconds'];
    if (t is int && t > 0) return t;
    return null;
  }

  Future<void> _speak() async {
    final text = "Step ${idx + 1}. $_currentStepText";
    await _tts.speak(text);
  }

  void _setupTimer() {
    _timer?.cancel();
    final seconds = _currentStepTimer;
    if (seconds != null) {
      _remainingSeconds = seconds;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) return;
        setState(() {
          if (_remainingSeconds! > 0) {
            _remainingSeconds = _remainingSeconds! - 1;
          } else {
            timer.cancel();
            _remainingSeconds = null;
          }
        });
      });
    } else {
      _remainingSeconds = null;
    }
  }

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    final mm = m.toString().padLeft(2, '0');
    final ss = s.toString().padLeft(2, '0');
    return "$mm:$ss";
  }

  void _nextStep() {
    if (idx < widget.steps.length - 1) {
      setState(() {
        idx++;
        _setupTimer();
      });
    }
  }

  void _previousStep() {
    if (idx > 0) {
      setState(() {
        idx--;
        _setupTimer();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.steps.length;

    if (total == 0) {
      return const Center(
        child: Text(
          "No available steps.",
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    final progress = (idx + 1) / total;

    Widget _buildTopImage() {
      final stepImg = _currentStepImage;
      if (stepImg != null) {
        return Image.asset(
          'assets/steps/$stepImg',
          height: 400,
          fit: BoxFit.contain,
        );
      }
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTopImage(),
        const SizedBox(height: 6),

        Text(
          "Step ${idx + 1} of $total",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 6),

        LinearProgressIndicator(value: progress),
        const SizedBox(height: 10),

        // Timer
        if (_remainingSeconds != null) ... [
          Align(
            alignment: Alignment.center,
            child: Chip(
              backgroundColor: Colors.blue.shade50,
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.timer, size: 16, color: Colors.blueAccent),
                  const SizedBox(width: 5),
                  Text(
                    _formatDuration(_remainingSeconds!),
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 211, 25, 0)),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],

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
              onPressed: idx > 0 ? _previousStep : null,
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
              onPressed: (idx < total - 1 && _remainingSeconds == null) ? _nextStep : null,
              icon: const Icon(Icons.arrow_forward),
              label: const Text("Next"),
            ),
          ],
        ),
      ],
    );
  }
}
