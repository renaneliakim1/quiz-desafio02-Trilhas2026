enum TopicCategory {
  linguagem('Linguagens'),
  biblioteca('Bibliotecas e Frameworks');

  const TopicCategory(this.label);

  final String label;
}

enum TechTopic {
  javascript('JavaScript', TopicCategory.linguagem),
  react('React', TopicCategory.biblioteca, language: 'JavaScript'),
  java('Java', TopicCategory.linguagem),
  flutter('Flutter', TopicCategory.biblioteca, language: 'Dart'),
  reactNative(
    'React Native',
    TopicCategory.biblioteca,
    language: 'JavaScript',
  ),
  kotlin('Kotlin', TopicCategory.linguagem),
  dart('Dart', TopicCategory.linguagem),
  swift('Swift', TopicCategory.linguagem);

  const TechTopic(this.label, this.category, {this.language});

  final String label;
  final TopicCategory category;
  final String? language;

  bool get isLanguage => category == TopicCategory.linguagem;

  String get displayLabel {
    final base = language;
    return base == null ? label : '$label ($base)';
  }
}
