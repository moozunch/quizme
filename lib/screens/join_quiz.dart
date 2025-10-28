import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class JoinQuizScreen extends StatefulWidget {
  const JoinQuizScreen({super.key});

  @override
  State<JoinQuizScreen> createState() => _JoinQuizScreenState();
}

class _JoinQuizScreenState extends State<JoinQuizScreen> {
  final _codeCtrl = TextEditingController();

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  void _join() {
    final code = _codeCtrl.text.trim();
    if (code.isEmpty) return;
    context.go('/quiz/$code/play');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Join Quiz')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(controller: _codeCtrl, decoration: const InputDecoration(labelText: 'Enter quiz code (ID)')),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _join, child: const Text('Join')),
          ],
        ),
      ),
    );
  }
}
