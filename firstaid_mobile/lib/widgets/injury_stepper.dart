import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

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

  bool get _hasSteps => widget.steps.isNotEmpty;

  Map<String, dynamic> get _currentStep {
    if (!_hasSteps) return const {};
    final raw = widget.steps[idx];

    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) return Map<String, dynamic>.from(raw);

    return <String, dynamic>{'text': raw.toString()};
  }

  String get _currentStepText {
    final text = _currentStep['text'];
    if (text is String && text.isNotEmpty) return text;
    return '';
  }

  String? get _currentStepImage {
    final step = _currentStep;
    final img = step['imageName']; 
    if (img is String && img.trim().isNotEmpty) {
      return img.trim();
    }
    return null;
  }

  int? get _currentStepTimer {
    final raw = _currentStep['timerSeconds'];
    if (raw == null) return null;

    if (raw is int && raw > 0) return raw;
    if (raw is double && raw > 0) return raw.round();
    if (raw is String) {
      final parsed = int.tryParse(raw);
      if (parsed != null && parsed > 0) return parsed;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _setupTimer();
  }

  @override
  void didUpdateWidget(covariant InjuryStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.steps != widget.steps) {
      idx = 0;
      _setupTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _tts.stop();
    super.dispose();
  }

  Future<void> _speak() async {
    final text = "Step ${idx + 1}. $_currentStepText";
    await _tts.speak(text);
  }

  void _setupTimer() {
    _timer?.cancel();
    final seconds = _currentStepTimer;

    // DEBUG: see what the step actually contains
    // (check this in your console)
    //print('Current step $idx: $_currentStep');
    //print(' -> imageName: ${_currentStep['imageName']}');
    // print(' -> timerSeconds: $seconds');

    if (seconds != null && seconds > 0) {
      _remainingSeconds = seconds;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) return;
        setState(() {
          if (_remainingSeconds! > 0) {
            _remainingSeconds = _remainingSeconds! - 1;
          } else {
            _remainingSeconds = null;
            timer.cancel();
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
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
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

        // Timer chip
        if (_remainingSeconds != null) ...[
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
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 211, 25, 0),
                    ),
                  ),
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
              onPressed:
                  (idx < total - 1 && _remainingSeconds == null) ? _nextStep : null,
              icon: const Icon(Icons.arrow_forward),
              label: const Text("Next"),
            ),
          ],
        ),
      ],
    );
  }
}
