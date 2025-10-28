class Question {
  String text;
  List<String> options;
  int correctIndex;

  Question({required this.text, required this.options, required this.correctIndex});

  factory Question.fromJson(Map<String, dynamic> j) => Question(
        text: j['text'] as String,
        options: List<String>.from(j['options'] as List<dynamic>),
        correctIndex: j['correctIndex'] as int,
      );

  Map<String, dynamic> toJson() => {
        'text': text,
        'options': options,
        'correctIndex': correctIndex,
      };
}
