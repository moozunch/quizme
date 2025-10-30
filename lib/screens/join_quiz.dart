import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/app_scaffold.dart';

class JoinQuizScreen extends StatefulWidget {
  const JoinQuizScreen({super.key});

  @override
  State<JoinQuizScreen> createState() => _JoinQuizScreenState();
}

class _JoinQuizScreenState extends State<JoinQuizScreen> {
  final _codeCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();

  @override
  void dispose() {
    _codeCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  void _join() {
    final code = _codeCtrl.text.trim();
    final name = _nameCtrl.text.trim();
    if (code.isEmpty || name.isEmpty) return;
    context.push('/quiz/$code/play', extra: name);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      titleText: 'Join Quiz',
      body: Column(
          children: [
            TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Your name')),
            const SizedBox(height: 8),
            TextField(controller: _codeCtrl, decoration: const InputDecoration(labelText: 'Enter quiz code (ID)')),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _join, child: const Text('Join')),
          ],
      ),
    );
  }
}
