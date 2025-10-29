import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/quiz.dart';
import '../provider/app_state.dart';

class QuizCard extends StatelessWidget {
  final Quiz quiz;
  const QuizCard({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
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
              onPressed: () => context.push('/quiz/${quiz.id}/play'),
            ),
            PopupMenuButton<String>(
              onSelected: (value) async {
                switch (value) {
                  case 'view':
                    context.push('/quiz/${quiz.id}');
                    break;
                  case 'copy':
                    await Clipboard.setData(ClipboardData(text: quiz.id));
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ID copied')));
                    }
                    break;
                  case 'delete':
                    final confirm = await showDialog<bool>(
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
                    if (confirm == true && context.mounted) {
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
