import 'difficulty.dart';
import 'topic.dart';

class Question {
  const Question({
    required this.id,
    required this.topic,
    required this.difficulty,
    required this.statement,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  }) : assert(
         correctIndex >= 0 && correctIndex < 4,
         'O índice da resposta correta deve estar entre 0 e 3.',
       );

  final String id;
  final TechTopic topic;
  final Difficulty difficulty;
  final String statement;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  String get correctOption => options[correctIndex];
}
