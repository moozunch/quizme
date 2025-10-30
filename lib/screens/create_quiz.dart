import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../provider/app_state.dart';
import '../models/question.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/section_title.dart';

class CreateQuizScreen extends StatefulWidget {
  const CreateQuizScreen({super.key});

  @override
  State<CreateQuizScreen> createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends State<CreateQuizScreen> {
  final _titleCtrl = TextEditingController();
  final _qText = TextEditingController();
  final _optCtrls = List.generate(4, (_) => TextEditingController());
  // -1 artinya belum dipilih jawaban benar
  int _correct = -1;

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
    if (text.isEmpty || opts.any((o) => o.isEmpty) || _correct < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi pertanyaan, opsi, dan pilih jawaban benar.')),
      );
      return;
    }
    setState(() {
      _questions.add(Question(text: text, options: opts, correctIndex: _correct));
      _qText.clear();
      for (final c in _optCtrls) {
        c.clear();
      }
      _correct = -1;
    });
  }

  Future<void> _saveQuiz() async {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty || _questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Isi judul dan tambahkan minimal 1 pertanyaan.')),
      );
      return;
    }
    final id = await context.read<AppState>().addQuiz(title, _questions);
    if (!mounted) return;
    context.push('/quiz/$id/created');
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      titleText: 'Create Quiz',
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'Quiz title')),
            const SizedBox(height: 12),
            TextField(controller: _qText, decoration: const InputDecoration(labelText: 'Question text')),
            const SizedBox(height: 8),
            const SectionTitle('Pilih jawaban yang benar:'),
            const SizedBox(height: 4),
            ...List.generate(4, (i) {
              final letter = String.fromCharCode(65 + i); // A, B, C, D
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: RadioListTile<int>(
                  value: i,
                  groupValue: _correct,
                  onChanged: (v) => setState(() => _correct = v ?? -1),
                  secondary: CircleAvatar(radius: 12, child: Text(letter)),
                  title: TextField(
                    controller: _optCtrls[i],
                    decoration: InputDecoration(labelText: 'Opsi $letter'),
                  ),
                ),
              );
            }),
            ElevatedButton.icon(onPressed: _addQuestion, icon: const Icon(Icons.add), label: const Text('Add question')),
            const SizedBox(height: 12),
            if (_questions.isNotEmpty) ...[
              const SectionTitle('Questions added:'),
              const SizedBox(height: 8),
              ..._questions.map((q) {
                final correctLetter = String.fromCharCode(65 + q.correctIndex);
                return ListTile(
                  title: Text(q.text),
                  subtitle: Text('Benar: $correctLetter. ${q.options[q.correctIndex]}'),
                );
              }),
            ],
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _saveQuiz, child: const Text('Save Quiz')),
          ],
        ),
      ),
    );
  }
}
