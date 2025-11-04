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

    // Compute readable text color if needed later (currently not used)
    // Color readableOnLocal(Color bg) {
    //   final l = bg.computeLuminance();
    //   return l > 0.6 ? Colors.black87 : Colors.white;
    // }
    Future<void> askNameAndStart() async {
      final name = await showNamePrompt(context);
      if (name != null && context.mounted) {
        context.push('/quiz/${quiz.id}/play', extra: name);
      }
    }
  final bg = pickCardColorLocal(quiz.id);
  // final fg = readableOnLocal(bg); // computed text color if needed later

    String pickHeaderImageLocal(String key) {
      // Use the 4 provided PNG files in assets/background
      const files = [
        'assets/background/img (1).png',
        'assets/background/img (2).png',
        'assets/background/img (3).png',
        'assets/background/img (4).png',
      ];
      var hash = 0;
      for (final c in key.codeUnits) {
        hash = ((hash << 5) - hash) + c;
        hash &= 0x7fffffff;
      }
      return files[hash % files.length];
    }

    final headerAsset = pickHeaderImageLocal(quiz.id);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: AppRadius.card,
        onTap: () => context.push('/quiz/${quiz.id}'),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header image with gradient overlay and title
            SizedBox(
              height: 110,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(headerAsset, fit: BoxFit.cover),
                  // Tint + gradient to ensure readability and brand color touch
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          bg.withValues(alpha: 0.55),
                          Colors.black.withValues(alpha: 0.25),
                        ],
                      ),
                    ),
                  ),
                  // Title and subtitle inside header
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          quiz.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${quiz.questions.length} questions',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.95),
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: PopupMenuButton<String>(
                      iconColor: Colors.white,
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
                  ),
                ],
              ),
            ),
            // Body
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'ID: ${quiz.id}',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  ElevatedButton(
                    onPressed: askNameAndStart,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      visualDensity: VisualDensity.compact,
                    ),
                    child: const Text("Let's go"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
