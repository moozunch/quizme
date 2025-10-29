import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';

import '../provider/app_state.dart';
import '../widgets/theme_toggle_action.dart';

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
      appBar: AppBar(
        title: Text(quiz.title),
        actions: [
          IconButton(
            tooltip: 'Copy ID',
            icon: const Icon(Icons.copy),
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: quiz.id));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ID copied')));
              }
            },
          ),
          IconButton(
            tooltip: 'Delete',
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Delete quiz?'),
                  content: const Text('Tindakan ini tidak dapat dibatalkan.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                    FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                  ],
                ),
              );
              if (ok == true && context.mounted) {
                await context.read<AppState>().removeQuiz(quiz.id);
                if (context.mounted) context.pop();
              }
            },
          ),
          const ThemeToggleAction(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${quiz.id}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 8),
            Text('Questions: ${quiz.questions.length}'),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: () => context.push('/quiz/${quiz.id}/play'), child: const Text('Start Quiz')),
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
      ),
    );
  }
}
