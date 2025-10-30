import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../provider/app_state.dart';
import '../widgets/app_scaffold.dart';

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
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(quiz?.title ?? 'Quiz', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text('Nama: $name'),
              const SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    Text('$score / $total', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(value: total == 0 ? 0 : score / total),
                  ],
                ),
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: () => context.go('/'),
                icon: const Icon(Icons.home),
                label: const Text('Kembali ke Home'),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => context.push('/quiz/$quizId'),
                icon: const Icon(Icons.visibility),
                label: const Text('Lihat Detail & Attempts'),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () => context.push('/quiz/$quizId/play', extra: name),
                icon: const Icon(Icons.refresh),
                label: const Text('Main lagi'),
              ),
            ],
        ),
      ),
    );
  }
}
