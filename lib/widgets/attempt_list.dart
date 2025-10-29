import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/app_state.dart';
import '../models/attempt.dart';

class AttemptList extends StatelessWidget {
  final String quizId;
  const AttemptList({super.key, required this.quizId});

  @override
  Widget build(BuildContext context) {
    final attempts = context.watch<AppState>().getAttempts(quizId);
    if (attempts.isEmpty) {
      return const Center(child: Text('Belum ada yang mengerjakan'));
    }
    return ListView.separated(
      itemCount: attempts.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) => _AttemptTile(attempt: attempts[i]),
    );
  }
}

class _AttemptTile extends StatelessWidget {
  final Attempt attempt;
  const _AttemptTile({required this.attempt});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(attempt.name),
      subtitle: Text('${attempt.score}/${attempt.total}'),
      trailing: Text(
        _fmt(attempt.submittedAt),
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }

  String _fmt(DateTime dt) {
    return '${dt.year}-${_two(dt.month)}-${_two(dt.day)} ${_two(dt.hour)}:${_two(dt.minute)}';
  }

  String _two(int n) => n.toString().padLeft(2, '0');
}
