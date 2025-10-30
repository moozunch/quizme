import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/app_state.dart';
import '../models/attempt.dart';
import 'package:go_router/go_router.dart';
import '../widgets/app_scaffold.dart';

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
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Question ${_index + 1} / ${quiz.questions.length}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(q.text, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            ...List.generate(q.options.length, (i) {
              final opt = q.options[i];
              final isSelected = _selected == i;
              return Card(
                color: isSelected ? Colors.blue.shade100 : null,
                child: ListTile(
                  title: Text(opt),
                  onTap: _selected == null ? () => _submitAnswer(i, q.correctIndex) : null,
                ),
              );
            }),
            const SizedBox(height: 12),
            if (_selected != null)
              ElevatedButton(
                onPressed: () async {
                  if (_index + 1 >= quiz.questions.length) {
                    // record attempt if name provided
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
            const SizedBox(height: 8),
            Text('Score: $_score', textAlign: TextAlign.right),
          ],
      ),
    );
  }
}
