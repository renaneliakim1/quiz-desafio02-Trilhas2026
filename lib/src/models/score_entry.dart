class ScoreEntry {
  const ScoreEntry({
    required this.name,
    required this.difficulty,
    required this.score,
    required this.total,
    required this.playedAt,
  });

  final String name;
  final String difficulty;
  final int score;
  final int total;
  final DateTime playedAt;

  double get percentage => total == 0 ? 0 : (score / total) * 100;

  String get formattedPlayedAt {
    String twoDigits(int value) => value.toString().padLeft(2, '0');
    return '${twoDigits(playedAt.day)}/${twoDigits(playedAt.month)}/'
        '${playedAt.year} ${twoDigits(playedAt.hour)}:${twoDigits(playedAt.minute)}';
  }

  Map<String, Object> toJson() {
    return {
      'name': name,
      'difficulty': difficulty,
      'score': score,
      'total': total,
      'playedAt': playedAt.toIso8601String(),
    };
  }

  factory ScoreEntry.fromJson(Map<String, dynamic> json) {
    return ScoreEntry(
      name: json['name'] as String? ?? 'Jogador',
      difficulty: json['difficulty'] as String? ?? 'Não informada',
      score: (json['score'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
      playedAt:
          DateTime.tryParse(json['playedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  static int compare(ScoreEntry a, ScoreEntry b) {
    final byPercentage = b.percentage.compareTo(a.percentage);
    if (byPercentage != 0) return byPercentage;

    final byScore = b.score.compareTo(a.score);
    if (byScore != 0) return byScore;

    return a.playedAt.compareTo(b.playedAt);
  }
}
