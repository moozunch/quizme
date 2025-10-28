import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../provider/app_state.dart';
import '../widgets/quiz_card.dart';
import '../widgets/theme_toggle_action.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('QuizMe'), actions: const [ThemeToggleAction()]),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.amber.shade50,
              child: const ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('Demo quiz tersedia'),
                subtitle: Text('Coba join dengan kode: QUIZ001'),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => context.go('/create'),
              icon: const Icon(Icons.create),
              label: const Text('Create Quiz'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => context.go('/join'),
              icon: const Icon(Icons.login),
              label: const Text('Join Quiz'),
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
      ),
    );
  }
}
