import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../provider/app_state.dart';
import '../models/question.dart';
import '../widgets/theme_toggle_action.dart';

class CreateQuizScreen extends StatefulWidget {
  const CreateQuizScreen({super.key});

  @override
  State<CreateQuizScreen> createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends State<CreateQuizScreen> {
  final _titleCtrl = TextEditingController();
  final _qText = TextEditingController();
  final _optCtrls = List.generate(4, (_) => TextEditingController());
  int _correct = 0;

  final List<Question> _questions = [];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _qText.dispose();
    for (final c in _optCtrls) { c.dispose(); }
    super.dispose();
  }

  void _addQuestion() {
    final text = _qText.text.trim();
    final opts = _optCtrls.map((c) => c.text.trim()).toList();
    if (text.isEmpty || opts.any((o) => o.isEmpty)) return;
    setState(() {
      _questions.add(Question(text: text, options: opts, correctIndex: _correct));
      _qText.clear();
      for (final c in _optCtrls) {
        c.clear();
      }
      _correct = 0;
    });
  }

  Future<void> _saveQuiz() async {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty || _questions.isEmpty) return;
    final id = await context.read<AppState>().addQuiz(title, _questions);
    if (!mounted) return;
    context.push('/quiz/$id/created');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Quiz'), actions: const [ThemeToggleAction()]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'Quiz title')),
            const SizedBox(height: 12),
            TextField(controller: _qText, decoration: const InputDecoration(labelText: 'Question text')),
            const SizedBox(height: 8),
            ...List.generate(4, (i) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Radio<int>(value: i, groupValue: _correct, onChanged: (v) => setState(() => _correct = v ?? 0)),
                    Expanded(child: TextField(controller: _optCtrls[i], decoration: InputDecoration(labelText: 'Option ${i + 1}'))),
                  ],
                ),
              );
            }),
            ElevatedButton.icon(onPressed: _addQuestion, icon: const Icon(Icons.add), label: const Text('Add question')),
            const SizedBox(height: 12),
            if (_questions.isNotEmpty) ...[
              const Text('Questions added:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ..._questions.map((q) => ListTile(title: Text(q.text), subtitle: Text('Options: ${q.options.length}'))),
            ],
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _saveQuiz, child: const Text('Save Quiz')),
          ],
        ),
      ),
    );
  }
}
