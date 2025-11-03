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
  void _prev() {
    if (_index > 0) {
      setState(() {
        _index--;
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
                Text(q.text, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: AppSpacing.sm),
                ...List.generate(q.options.length, (i) {
                  final opt = q.options[i];
                  final isSelected = _selected == i;
                  final scheme = Theme.of(context).colorScheme;
                  final bg = isSelected ? scheme.secondaryContainer : scheme.surface;
                  final fg = isSelected ? scheme.onSecondaryContainer : scheme.onSurface;
                  final letter = String.fromCharCode(65 + i);
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: AppRadius.button,
                      border: Border.all(color: isSelected ? scheme.secondary : scheme.outlineVariant, width: 1.2),
                    ),
                    child: InkWell(
                      borderRadius: AppRadius.button,
                      onTap: _selected == null ? () => _submitAnswer(i, q.correctIndex) : null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 14,
                              backgroundColor: isSelected ? scheme.secondary : scheme.surface,
                              child: Text(letter, style: TextStyle(color: isSelected ? scheme.onSecondary : scheme.onSurface)),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(opt, style: TextStyle(color: fg, fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: AppSpacing.md),
                if (_selected != null)
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: _prev,
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Previous'),
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
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
                        icon: Icon(_index + 1 >= quiz.questions.length ? Icons.check : Icons.arrow_forward),
                        label: Text(_index + 1 >= quiz.questions.length ? 'Finish' : 'Next'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
