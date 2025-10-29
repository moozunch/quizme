class Attempt {
  final String name;
  final int score;
  final int total;
  final DateTime submittedAt;

  Attempt({required this.name, required this.score, required this.total, DateTime? submittedAt})
      : submittedAt = submittedAt ?? DateTime.now();

  factory Attempt.fromJson(Map<String, dynamic> j) => Attempt(
        name: j['name'] as String,
        score: j['score'] as int,
        total: j['total'] as int,
        submittedAt: DateTime.parse(j['submittedAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'score': score,
        'total': total,
        'submittedAt': submittedAt.toIso8601String(),
      };
}
