import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../provider/app_state.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/result_celebration.dart';
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
        body: ResultCelebration(
          title: 'Congrats! The quiz is done',
          caption: "Hopefully, the results are satisfying and provide new insights.",
          score: score,
          total: total,
          onHome: () => context.go('/'),
          onDetail: () => context.push('/quiz/$quizId'),
          onShare: () async {
            final text = '${quiz?.title ?? 'Quiz'}\n$name: $score/$total';
            await copyToClipboard(context, text, snack: 'Result copied');
          },
        ),
      ),
    );
  }
}
