import 'question.dart';
import 'attempt.dart';

class Quiz {
  String id;
  String title;
  List<Question> questions;
  List<Attempt> attempts;

  Quiz({required this.id, required this.title, required this.questions, List<Attempt>? attempts})
      : attempts = attempts ?? <Attempt>[];

  factory Quiz.create({required String title, required List<Question> questions}) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
  return Quiz(id: id, title: title, questions: questions, attempts: []);
  }

  factory Quiz.fromJson(Map<String, dynamic> j) => Quiz(
        id: j['id'] as String,
        title: j['title'] as String,
        questions: (j['questions'] as List<dynamic>)
            .map((e) => Question.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
    attempts: (j['attempts'] as List<dynamic>? ?? const [])
      .map((e) => Attempt.fromJson(Map<String, dynamic>.from(e as Map)))
      .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
    'questions': questions.map((q) => q.toJson()).toList(),
    'attempts': attempts.map((a) => a.toJson()).toList(),
      };
}
