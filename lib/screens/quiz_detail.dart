import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../provider/app_state.dart';

class QuizDetailScreen extends StatelessWidget {
  final String quizId;
  const QuizDetailScreen({super.key, required this.quizId});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final quiz = appState.getById(quizId);
    if (quiz == null) {
      return Scaffold(appBar: AppBar(title: const Text('Quiz not found')), body: const Center(child: Text('Quiz not found')));
    }
    return Scaffold(
      appBar: AppBar(title: Text(quiz.title)),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${quiz.id}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 8),
            Text('Questions: ${quiz.questions.length}'),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: () => context.go('/quiz/${quiz.id}/play'), child: const Text('Start Quiz')),
            const SizedBox(height: 12),
            const Text('Preview:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: quiz.questions.length,
                itemBuilder: (c, i) => ListTile(
                  title: Text(quiz.questions[i].text),
                  subtitle: Text('Options: ${quiz.questions[i].options.join(', ')}'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
