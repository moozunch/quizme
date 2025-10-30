import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../provider/app_state.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/attempt_list.dart';
import '../widgets/copy_code_row.dart';
import '../widgets/dialogs.dart';

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
    return AppScaffold(
      titleText: 'Quiz Created',
      padding: const EdgeInsets.all(16),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Berhasil membuat quiz!', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Judul: ${quiz.title}'),
            CopyCodeRow(code: quiz.id, snackText: 'Kode disalin'),
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
                  final ok = await showDeleteConfirm(context);
                  if (ok && context.mounted) {
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
    );
  }
}
