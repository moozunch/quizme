import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../provider/app_state.dart';
import '../widgets/theme_toggle_action.dart';
import '../widgets/attempt_list.dart';

class QuizCreatedScreen extends StatelessWidget {
  final String quizId;
  const QuizCreatedScreen({super.key, required this.quizId});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final quiz = appState.getById(quizId);
    if (quiz == null) {
      return const Scaffold(body: Center(child: Text('Quiz not found')));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Created'), actions: const [ThemeToggleAction()]),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Berhasil membuat quiz!', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Judul: ${quiz.title}'),
            Row(
              children: [
                Expanded(child: Text('Kode: ${quiz.id}', style: const TextStyle(fontWeight: FontWeight.bold))),
                IconButton(
                  icon: const Icon(Icons.copy),
                  tooltip: 'Copy code',
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: quiz.id));
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Kode disalin')));
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(spacing: 8, children: [
              FilledButton.icon(
                onPressed: () => context.push('/quiz/${quiz.id}'),
                icon: const Icon(Icons.visibility),
                label: const Text('View'),
              ),
              OutlinedButton.icon(
                onPressed: () => context.push('/quiz/${quiz.id}/play'),
                icon: const Icon(Icons.play_arrow),
                label: const Text('Try Play'),
              ),
              OutlinedButton.icon(
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
                    if (context.mounted) context.go('/');
                  }
                },
                icon: const Icon(Icons.delete_outline),
                label: const Text('Delete'),
              ),
            ]),
            const SizedBox(height: 16),
            Text('Yang sudah mengerjakan', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Expanded(child: AttemptList(quizId: quiz.id)),
          ],
        ),
      ),
    );
  }
}
