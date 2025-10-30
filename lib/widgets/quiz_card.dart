import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/quiz.dart';
import '../provider/app_state.dart';
import 'dialogs.dart';

class QuizCard extends StatelessWidget {
  final Quiz quiz;
  const QuizCard({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    Future<void> askNameAndStart() async {
      final name = await showNamePrompt(context);
      if (name != null && context.mounted) {
        context.push('/quiz/${quiz.id}/play', extra: name);
      }
    }
    return Card(
      child: ListTile(
        title: Text(quiz.title),
        subtitle: Text('${quiz.questions.length} questions\nID: ${quiz.id}', maxLines: 2),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'Play',
              icon: const Icon(Icons.play_arrow),
              onPressed: askNameAndStart,
            ),
            PopupMenuButton<String>(
              onSelected: (value) async {
                switch (value) {
                  case 'view':
                    context.push('/quiz/${quiz.id}');
                    break;
                  case 'copy':
                    await copyToClipboard(context, quiz.id, snack: 'ID copied');
                    break;
                  case 'delete':
                    final confirm = await showDeleteConfirm(context);
                    if (confirm && context.mounted) {
                      await context.read<AppState>().removeQuiz(quiz.id);
                    }
                    break;
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'view', child: Text('View')),
                PopupMenuItem(value: 'copy', child: Text('Copy ID')),
                PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          ],
        ),
        onTap: () => context.push('/quiz/${quiz.id}'),
      ),
    );
  }
}
