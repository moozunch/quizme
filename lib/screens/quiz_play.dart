import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/app_state.dart';
import '../models/attempt.dart';
import 'package:go_router/go_router.dart';
import '../widgets/app_scaffold.dart';
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
    final scheme = Theme.of(context).colorScheme;
    return AppScaffold(
      title: Text(quiz.title),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Progress steps + header question
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.lg),
                decoration: BoxDecoration(
                  color: scheme.secondaryContainer,
                  borderRadius: AppRadius.button,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        ...List.generate(quiz.questions.length, (i) => Expanded(
                              child: Container(
                                height: 6,
                                margin: EdgeInsets.only(right: i == quiz.questions.length - 1 ? 0 : 6),
                                decoration: BoxDecoration(
                                  color: i <= _index ? scheme.onSecondaryContainer.withValues(alpha: 0.9) : scheme.onSecondaryContainer.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              ),
                            )),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 180),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                          child: Text(
                            q.text,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: scheme.onSecondaryContainer,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              // Options grid (2 columns)
              LayoutBuilder(
                builder: (context, constraints) {
                  final gap = 12.0;
                  final itemWidth = (constraints.maxWidth - gap) / 2;
                  return Wrap(
                    spacing: gap,
                    runSpacing: gap,
                    children: List.generate(q.options.length, (i) {
                      final opt = q.options[i];
                      final isSelected = _selected == i;
                      return SizedBox(
                        width: itemWidth,
                        child: _OptionTile(
                          label: opt,
                          selected: isSelected,
                          onTap: _selected == null ? () => _submitAnswer(i, q.correctIndex) : null,
                        ),
                      );
                    }),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.md),
              if (_selected != null)
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: _prev,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.arrow_back_rounded, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 8),
                          const Text('Previous'),
                        ],
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
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
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_index + 1 >= quiz.questions.length ? 'Finish' : 'Next'),
                          const SizedBox(width: 8),
                          Icon(
                            _index + 1 >= quiz.questions.length ? Icons.check_rounded : Icons.arrow_forward_rounded,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  const _OptionTile({required this.label, required this.selected, this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = selected ? scheme.onSurface : scheme.surface;
    final fg = selected ? scheme.surface : scheme.onSurface;
    const double h = 56;
    return Material(
      color: bg,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.button,
        side: BorderSide(color: selected ? scheme.onSurface : scheme.outlineVariant, width: 1.2),
      ),
      child: InkWell(
        borderRadius: AppRadius.button,
        onTap: onTap,
        child: SizedBox(
          height: h,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Centered label
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: fg, fontWeight: FontWeight.w700),
                ),
              ),
              // Selected check dot on the left
              if (selected)
                Positioned(
                  left: 12,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check, size: 14, color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
