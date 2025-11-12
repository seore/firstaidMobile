import 'package:flutter/material.dart';
import '../models/injury.dart';
import 'quiz_play_screen.dart';

class QuizScreen extends StatelessWidget {
  final List<Injury> injuries;

  const QuizScreen({super.key, required this.injuries});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Yourself'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              'Test your first-aid knowledge.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: const Icon(Icons.shuffle),
                title: const Text('Mixed Injury Quiz'),
                subtitle: const Text('Random questions from different injuries'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          QuizPlayScreen(injuries: injuries, questionCount: 8),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
