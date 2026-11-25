import 'dart:math';

import '../models/difficulty.dart';
import '../models/question.dart';
import '../models/topic.dart';

class PresentedQuestion {
  PresentedQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
  });

  final Question question;
  final List<String> options;
  final int correctIndex;

  String get correctOption => options[correctIndex];

  factory PresentedQuestion.shuffled(Question question, Random random) {
    final order = List<int>.generate(question.options.length, (i) => i)
      ..shuffle(random);
    final options = [for (final index in order) question.options[index]];
    final correctIndex = order.indexOf(question.correctIndex);

    return PresentedQuestion(
      question: question,
      options: options,
      correctIndex: correctIndex,
    );
  }
}

class QuizEngine {
  QuizEngine({required List<Question> bank, Random? random})
    : bank = List.unmodifiable(bank),
      _random = random ?? Random();

  final List<Question> bank;
  final Random _random;

  static const int questionsPerQuiz = 10;

  List<PresentedQuestion> buildQuiz({
    Difficulty? difficulty,
    TopicCategory? category,
    int count = questionsPerQuiz,
  }) {
    final selected = _selectQuestions(
      difficulty: difficulty,
      category: category,
      count: count,
    );
    return [
      for (final question in selected)
        PresentedQuestion.shuffled(question, _random),
    ];
  }

  List<Question> _selectQuestions({
    Difficulty? difficulty,
    TopicCategory? category,
    required int count,
  }) {
    final pool = bank
        .where(
          (question) =>
              (difficulty == null || question.difficulty == difficulty) &&
              (category == null || question.topic.category == category),
        )
        .toList();

    if (pool.isEmpty || count <= 0) return [];

    final effectiveCount = min(count, pool.length);
    final chosen = <Question>[];
    final chosenIds = <String>{};

    void take(Question question) {
      if (chosen.length >= effectiveCount) return;
      if (chosenIds.add(question.id)) chosen.add(question);
    }

    final topics = pool.map((question) => question.topic).toSet().toList()
      ..shuffle(_random);

    for (final topic in topics) {
      final candidates =
          pool
              .where(
                (question) =>
                    question.topic == topic && !chosenIds.contains(question.id),
              )
              .toList()
            ..shuffle(_random);
      if (candidates.isNotEmpty) take(candidates.first);
    }

    final remaining =
        pool.where((question) => !chosenIds.contains(question.id)).toList()
          ..shuffle(_random);

    for (final question in remaining) {
      if (chosen.length >= effectiveCount) break;
      take(question);
    }

    if (difficulty == null && effectiveCount >= Difficulty.values.length) {
      _ensureAllDifficulties(chosen, chosenIds, pool);
    }

    chosen.shuffle(_random);
    return chosen;
  }

  void _ensureAllDifficulties(
    List<Question> chosen,
    Set<String> chosenIds,
    List<Question> pool,
  ) {
    for (final difficulty in Difficulty.values) {
      if (chosen.any((question) => question.difficulty == difficulty)) {
        continue;
      }

      Question? source;
      Question? replacement;

      for (final picked in chosen) {
        final candidates = pool
            .where(
              (question) =>
                  question.topic == picked.topic &&
                  question.difficulty == difficulty &&
                  !chosenIds.contains(question.id),
            )
            .toList();

        if (candidates.isNotEmpty) {
          source = picked;
          replacement = candidates[_random.nextInt(candidates.length)];
          break;
        }
      }

      if (source == null || replacement == null) continue;

      final index = chosen.indexOf(source);
      chosenIds.remove(source.id);
      chosen[index] = replacement;
      chosenIds.add(replacement.id);
    }
  }
}
