import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/quiz.dart';

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
        trailing: IconButton(
          icon: const Icon(Icons.play_arrow),
          onPressed: () => context.go('/quiz/${quiz.id}/play'),
        ),
        onTap: () => context.go('/quiz/${quiz.id}'),
      ),
    );
  }
}
