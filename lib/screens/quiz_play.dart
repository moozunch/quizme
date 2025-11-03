import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/app_state.dart';
import '../models/attempt.dart';
import 'package:go_router/go_router.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/section_card.dart';
import '../styles/tokens.dart';

class QuizPlayScreen extends StatefulWidget {
  final String quizId;
  final String? participantName;
  const QuizPlayScreen({super.key, required this.quizId, this.participantName});

  @override
  State<QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends State<QuizPlayScreen> {
  int _index = 0;
  int _score = 0;
  int? _selected;

  void _submitAnswer(int chosen, int correct) {
    setState(() {
      _selected = chosen;
      if (chosen == correct) _score++;
    });
  }

  void _next(int total) {
    if (_index + 1 < total) {
      setState(() {
        _index++;
        _selected = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final quiz = appState.getById(widget.quizId);
    if (quiz == null) return Scaffold(body: Center(child: Text('Quiz not found')));

    final q = quiz.questions[_index];
    return AppScaffold(
      title: Text(quiz.title),
      body: ListView(
        children: [
          SectionCard(
            child: Row(
              children: [
                Chip(label: Text('Q ${_index + 1}/${quiz.questions.length}')),
                const SizedBox(width: AppSpacing.sm),
                if ((widget.participantName ?? '').isNotEmpty)
                  Chip(label: Text(widget.participantName!)),
                const Spacer(),
                Text('Score: $_score', style: Theme.of(context).textTheme.labelLarge),
              ],
            ),
          ),
          SectionCard(
            title: 'Question',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(q.text, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: AppSpacing.sm),
                ...List.generate(q.options.length, (i) {
                  final opt = q.options[i];
                  final isSelected = _selected == i;
                  final selectedColor = Theme.of(context).colorScheme.primaryContainer;
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? selectedColor : Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: AppRadius.card,
                    ),
                    child: ListTile(
                      title: Text(opt),
                      trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.green) : null,
                      onTap: _selected == null ? () => _submitAnswer(i, q.correctIndex) : null,
                    ),
                  );
                }),
                const SizedBox(height: AppSpacing.md),
                if (_selected != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_index + 1 >= quiz.questions.length) {
                          final name = widget.participantName;
                          if (name != null && name.isNotEmpty) {
                            await context.read<AppState>().addAttempt(
                                  quiz.id,
                                  Attempt(name: name, score: _score, total: quiz.questions.length),
                                );
                          }
                          if (!context.mounted) return;
                          context.push('/quiz/${quiz.id}/result', extra: {
                            'score': _score,
                            'total': quiz.questions.length,
                            'name': name,
                          });
                        } else {
                          _next(quiz.questions.length);
                        }
                      },
                      child: Text(_index + 1 >= quiz.questions.length ? 'Finish' : 'Next'),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
