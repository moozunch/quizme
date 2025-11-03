import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../provider/app_state.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/dialogs.dart';
import '../widgets/section_card.dart';
import '../widgets/attempt_list.dart';
import '../styles/tokens.dart';

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
    return AppScaffold(
      title: Text(quiz.title),
      actions: [
        IconButton(
          tooltip: 'Copy ID',
          icon: const Icon(Icons.copy),
          onPressed: () => copyToClipboard(context, quiz.id, snack: 'ID copied'),
        ),
        IconButton(
          tooltip: 'Delete',
          icon: const Icon(Icons.delete_outline),
          onPressed: () async {
            final ok = await showDeleteConfirm(context);
            if (ok && context.mounted) {
              await context.read<AppState>().removeQuiz(quiz.id);
              if (context.mounted) context.pop();
            }
          },
        ),
      ],
      body: ListView(
        children: [
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: [
                    Chip(label: Text('ID: ${quiz.id}')),
                    Chip(label: Text('${quiz.questions.length} questions')),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Get ready to start this quiz',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: AppSpacing.sm),
                ElevatedButton(
                  onPressed: () async {
                    final name = await showNamePrompt(context);
                    if (name != null && context.mounted) {
                      context.push('/quiz/${quiz.id}/play', extra: name);
                    }
                  },
                  child: const Text('Start Quiz'),
                ),
              ],
            ),
          ),

          SectionCard(
            title: 'Preview',
            child: Column(
              children: [
                ...List.generate(
                  quiz.questions.length,
                  (i) => Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: AppRadius.card,
                    ),
                    child: ListTile(
                      title: Text(quiz.questions[i].text),
                      subtitle: Text('Options: ${quiz.questions[i].options.join(', ')}'),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SectionCard(
            title: 'Attempts',
            child: SizedBox(
              height: 220,
              child: AttemptList(quizId: quiz.id),
            ),
          ),
        ],
      ),
    );
  }
}
