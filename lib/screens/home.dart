import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../provider/app_state.dart';
import '../widgets/quiz_card.dart';
import '../widgets/action_card.dart';
import '../widgets/app_scaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return AppScaffold(
      titleText: 'QuizMe',
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final gap = 12.0;
                final isTwoCol = constraints.maxWidth >= 420;
                final itemWidth = isTwoCol ? (constraints.maxWidth - gap) / 2 : constraints.maxWidth;
                return Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: [
                    SizedBox(
                      width: itemWidth,
                      child: ActionCard(
                        title: 'Create Quiz',
                        badge: 'NEW',
                        caption: 'Start',
                        icon: Icons.play_arrow_rounded,
                        onTap: () => context.push('/create'),
                        accent: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    SizedBox(
                      width: itemWidth,
                      child: ActionCard(
                        title: 'Join Quiz',
                        caption: 'Enter code',
                        icon: Icons.play_arrow_rounded,
                        onTap: () => context.push('/join'),
                        accent: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 12),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (appState.quizzes.isEmpty) {
                    return const Center(child: Text('No quizzes yet. Create one!'));
                  }
                  final isWide = constraints.maxWidth >= 600;
                  if (isWide) {
                    final crossCount = constraints.maxWidth >= 900 ? 3 : 2;
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossCount,
                        childAspectRatio: 3.2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: appState.quizzes.length,
                      itemBuilder: (context, i) => QuizCard(quiz: appState.quizzes[i]),
                    );
                  }
                  return ListView.builder(
                    itemCount: appState.quizzes.length,
                    itemBuilder: (context, i) => QuizCard(quiz: appState.quizzes[i]),
                  );
                },
              ),
            ),
          ],
      ),
    );
  }
}
