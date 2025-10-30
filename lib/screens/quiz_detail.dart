import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../provider/app_state.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/dialogs.dart';

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
    return AppScaffold(
      title: Text(quiz.title),
      actions: [
        IconButton(
          tooltip: 'Copy ID',
          icon: const Icon(Icons.copy),
          onPressed: () => copyToClipboard(context, quiz.id, snack: 'ID copied'),
        ),
        IconButton(
          tooltip: 'Delete',
          icon: const Icon(Icons.delete_outline),
          onPressed: () async {
            final ok = await showDeleteConfirm(context);
            if (ok && context.mounted) {
              await context.read<AppState>().removeQuiz(quiz.id);
              if (context.mounted) context.pop();
            }
          },
        ),
      ],
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${quiz.id}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 8),
            Text('Questions: ${quiz.questions.length}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final name = await showNamePrompt(context);
                if (name != null && context.mounted) {
                  context.push('/quiz/${quiz.id}/play', extra: name);
                }
              },
              child: const Text('Start Quiz'),
            ),
            const SizedBox(height: 12),
            const Text('Preview:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: [
                  ...List.generate(quiz.questions.length, (i) => ListTile(
                        title: Text(quiz.questions[i].text),
                        subtitle: Text('Options: ${quiz.questions[i].options.join(', ')}'),
                      )),
                  const SizedBox(height: 12),
                  const Divider(),
                  const Text('Attempts', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...quiz.attempts.map((a) => ListTile(
                        title: Text(a.name),
                        subtitle: Text('${a.score}/${a.total}'),
                        trailing: Text('${a.submittedAt.hour.toString().padLeft(2, '0')}:${a.submittedAt.minute.toString().padLeft(2, '0')}'),
                      )),
                ],
              ),
            ),
          ],
      ),
    );
  }
}
