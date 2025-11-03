import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/quiz.dart';
import '../provider/app_state.dart';
import '../styles/tokens.dart';
import 'dialogs.dart';

class QuizCard extends StatelessWidget {
  final Quiz quiz;
  const QuizCard({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    Color pickCardColorLocal(String key) {
      final list = CardPalette.colors;
      if (key.isEmpty) return list.first;
      var hash = 0;
      for (final c in key.codeUnits) {
        hash = ((hash << 5) - hash) + c;
        hash &= 0x7fffffff;
      }
      return list[hash % list.length];
    }

    Color readableOnLocal(Color bg) {
      final l = bg.computeLuminance();
      return l > 0.6 ? Colors.black87 : Colors.white;
    }
    Future<void> askNameAndStart() async {
      final name = await showNamePrompt(context);
      if (name != null && context.mounted) {
        context.push('/quiz/${quiz.id}/play', extra: name);
      }
    }
  final bg = pickCardColorLocal(quiz.id);
  final fg = readableOnLocal(bg);

    return Card(
      color: bg,
      child: ListTile(
        title: Text(quiz.title, style: TextStyle(color: fg)),
        subtitle: Text('${quiz.questions.length} questions\nID: ${quiz.id}', maxLines: 2, style: TextStyle(color: fg.withValues(alpha: 0.9), fontSize: 14)),
        isThreeLine: true, 
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'Play',
              style: IconButton.styleFrom(
                foregroundColor: fg,
              ),
              iconSize: 24,
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
