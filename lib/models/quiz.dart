import 'question.dart';

class Quiz {
  String id;
  String title;
  List<Question> questions;

  Quiz({required this.id, required this.title, required this.questions});

  factory Quiz.create({required String title, required List<Question> questions}) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    return Quiz(id: id, title: title, questions: questions);
  }

  factory Quiz.fromJson(Map<String, dynamic> j) => Quiz(
        id: j['id'] as String,
        title: j['title'] as String,
        questions: (j['questions'] as List<dynamic>)
            .map((e) => Question.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'questions': questions.map((q) => q.toJson()).toList(),
      };
}
