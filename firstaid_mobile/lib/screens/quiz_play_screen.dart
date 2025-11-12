import 'dart:math';
import 'package:flutter/material.dart';
import '../models/injury.dart';

class QuizPlayScreen extends StatefulWidget {
  final List<Injury> injuries;
  final int questionCount;

  const QuizPlayScreen({
    super.key,
    required this.injuries,
    this.questionCount = 8,
  });

  @override
  State<QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends State<QuizPlayScreen> {
  late List<_QuizQuestion> _questions;
  int _index = 0;
  int _score = 0;
  bool _answered = false;
  String? _selectedOption;

  @override
  void initState() {
    super.initState();
    _questions = _generateQuestions(widget.injuries, widget.questionCount);
  }

  List<_QuizQuestion> _generateQuestions(List<Injury> injuries, int count) {
    final rnd = Random();
    final questions = <_QuizQuestion>[];

    final usable = injuries
        .where((i) => i.steps.isNotEmpty)
        .toList();

    usable.shuffle();

    for (var injury in usable) {
      if (questions.length >= count) break;
      final stepText = injury.steps.first.toString();

      // pick 3 other injuries as distractors
      final others = usable.where((i) => i != injury).toList()..shuffle();
      final options = <String>[];
      options.add(injury.name);
      options.addAll(others.take(3).map((e) => e.name));
      options.shuffle();

      questions.add(
        _QuizQuestion(
          question: 'Which injury does this step belong to?\n\n"$stepText"',
          correctAnswer: injury.name,
          options: options,
        ),
      );
    }

    return questions;
  }

  void _selectOption(String option) {
    if (_answered) return;

    setState(() {
      _answered = true;
      _selectedOption = option;
      if (option == _questions[_index].correctAnswer) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_index < _questions.length - 1) {
      setState(() {
        _index++;
        _answered = false;
        _selectedOption = null;
      });
    } else {
      _showResult();
    }
  }

  void _showResult() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Quiz complete'),
        content: Text('You scored $_score / ${_questions.length}.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Back'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz')),
        body: const Center(child: Text('Not enough data to build a quiz.')),
      );
    }

    final q = _questions[_index];
    final progress = (_index + 1) / _questions.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 12),
            Text(
              'Question ${_index + 1} of ${_questions.length}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Text(
              q.question,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
            const SizedBox(height: 20),
            ...q.options.map((opt) {
              final isCorrect = opt == q.correctAnswer;
              final isSelected = opt == _selectedOption;

              Color? tileColor;
              if (_answered && isSelected && isCorrect) {
                tileColor = Colors.green[100];
              } else if (_answered && isSelected && !isCorrect) {
                tileColor = Colors.red[100];
              }

              return Card(
                color: tileColor,
                child: ListTile(
                  title: Text(opt),
                  onTap: () => _selectOption(opt),
                ),
              );
            }),
            const Spacer(),
            ElevatedButton(
              onPressed: _answered ? _nextQuestion : null,
              child: Text(
                _index < _questions.length - 1 ? 'Next' : 'Finish',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuizQuestion {
  final String question;
  final String correctAnswer;
  final List<String> options;

  _QuizQuestion({
    required this.question,
    required this.correctAnswer,
    required this.options,
  });
}
