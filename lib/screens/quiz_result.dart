import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../provider/app_state.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/dialogs.dart';

class QuizResultScreen extends StatelessWidget {
  final String quizId;
  final int score;
  final int total;
  final String? participantName;

  const QuizResultScreen({super.key, required this.quizId, required this.score, required this.total, this.participantName});

  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<AppState>().getById(quizId);
    final name = (participantName ?? '').isEmpty ? 'Guest' : participantName!;
  final isGood = (score * 2) >= total; // pass if >= 50%
  final assetPath = isGood ? 'assets/png/good_result.png' : 'assets/png/bad_result.png';
  final title = score == total
    ? 'Perfect Scorer'
    : (isGood ? 'Great Job' : 'Keep Trying');
  final caption = score == total
    ? 'Your flawless quiz performance sets a new standard of excellence.'
    : (isGood
      ? 'Nice work, $name! You passed the quiz and gained new insights.'
      : 'Not quite there yet, $name. Keep practicing and try again!');

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.go('/');
        }
      },
      child: AppScaffold(
        titleText: 'Result',
        padding: const EdgeInsets.all(16),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Illustration
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 16),
                  child: Image.asset(
                    assetPath,
                    width: 350,
                    height: 350,
                    fit: BoxFit.contain,
                  ),
                ),
                // Title
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 8),
                // Caption
                Text(
                  caption,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 16),
                // Score badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bolt_rounded, size: 18, color: Theme.of(context).colorScheme.onSecondaryContainer),
                      const SizedBox(width: 8),
                      Text(
                        '$score / $total',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondaryContainer,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Actions
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OutlinedButton(
                      onPressed: () => context.push('/quiz/$quizId'),
                      child: const Text('View Quiz'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () => context.go('/'),
                      child: const Text('Home'),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: () async {
                        final text = '${quiz?.title ?? 'Quiz'}\n$name: $score/$total';
                        await copyToClipboard(context, text, snack: 'Result copied');
                      },
                      child: const Text('Share'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
