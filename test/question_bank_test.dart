import 'dart:io';
import 'dart:math';

import 'package:quiz_programacao/quiz_programacao.dart';
import 'package:test/test.dart';

void main() {
  group('Banco de perguntas', () {
    test('tem pelo menos 10 perguntas em cada dificuldade', () {
      for (final difficulty in Difficulty.values) {
        final total = questionBank
            .where((question) => question.difficulty == difficulty)
            .length;

        expect(
          total,
          greaterThanOrEqualTo(QuizEngine.questionsPerQuiz),
          reason: 'Dificuldade ${difficulty.label}',
        );
      }
    });

    test('cada pergunta tem 4 alternativas válidas e uma explicação', () {
      for (final question in questionBank) {
        expect(question.options, hasLength(4), reason: question.id);
        expect(
          question.correctIndex,
          inInclusiveRange(0, 3),
          reason: question.id,
        );
        expect(question.statement.trim(), isNotEmpty, reason: question.id);
        expect(question.explanation.trim(), isNotEmpty, reason: question.id);
        expect(
          question.options.toSet(),
          hasLength(4),
          reason: 'Alternativas duplicadas em ${question.id}',
        );
      }
    });

    test('os identificadores das perguntas são únicos', () {
      final ids = questionBank.map((question) => question.id).toSet();
      expect(ids, hasLength(questionBank.length));
    });

    test('todas as tecnologias têm perguntas em todas as dificuldades', () {
      for (final topic in TechTopic.values) {
        for (final difficulty in Difficulty.values) {
          final total = questionBank
              .where(
                (question) =>
                    question.topic == topic &&
                    question.difficulty == difficulty,
              )
              .length;

          expect(
            total,
            greaterThan(0),
            reason: '${topic.label} / ${difficulty.label}',
          );
        }
      }
    });
  });

  group('QuizEngine', () {
    test(
      'seleciona 10 perguntas sem repetição e cobre todas as tecnologias',
      () {
        for (final difficulty in Difficulty.values) {
          final engine = QuizEngine(bank: questionBank, random: Random(42));
          final quiz = engine.buildQuiz(difficulty: difficulty);

          expect(quiz, hasLength(QuizEngine.questionsPerQuiz));
          expect(
            quiz.map((presented) => presented.question.id).toSet(),
            hasLength(QuizEngine.questionsPerQuiz),
          );
          expect(
            quiz.map((presented) => presented.question.topic).toSet(),
            hasLength(TechTopic.values.length),
          );
          expect(
            quiz.every(
              (presented) => presented.question.difficulty == difficulty,
            ),
            isTrue,
          );
        }
      },
    );

    test('modo misto inclui todas as dificuldades e tecnologias', () {
      final engine = QuizEngine(bank: questionBank, random: Random(7));
      final quiz = engine.buildQuiz();

      expect(quiz, hasLength(QuizEngine.questionsPerQuiz));
      expect(
        quiz.map((presented) => presented.question.id).toSet(),
        hasLength(QuizEngine.questionsPerQuiz),
      );
      expect(
        quiz.map((presented) => presented.question.topic).toSet(),
        hasLength(TechTopic.values.length),
      );
      expect(
        quiz.map((presented) => presented.question.difficulty).toSet(),
        hasLength(Difficulty.values.length),
      );
    });

    test('embaralha as alternativas mantendo a resposta correta', () {
      final engine = QuizEngine(bank: questionBank, random: Random(1));
      final quiz = engine.buildQuiz(difficulty: Difficulty.facil);

      for (final presented in quiz) {
        expect(presented.options.toSet(), presented.question.options.toSet());
        expect(
          presented.options[presented.correctIndex],
          presented.question.correctOption,
        );
      }
    });
  });

  group('ScoreEntry', () {
    test('serializa e desserializa mantendo os dados', () {
      final original = ScoreEntry(
        name: 'Ana',
        difficulty: 'Fácil',
        score: 8,
        total: 10,
        playedAt: DateTime(2026, 11, 24, 14, 30),
      );

      final copy = ScoreEntry.fromJson(original.toJson());

      expect(copy.name, original.name);
      expect(copy.difficulty, original.difficulty);
      expect(copy.score, original.score);
      expect(copy.total, original.total);
      expect(copy.playedAt, original.playedAt);
    });

    test('ordena por porcentagem e depois por acertos', () {
      final entries = [
        ScoreEntry(
          name: 'A',
          difficulty: 'Fácil',
          score: 7,
          total: 10,
          playedAt: DateTime(2026),
        ),
        ScoreEntry(
          name: 'B',
          difficulty: 'Difícil',
          score: 9,
          total: 10,
          playedAt: DateTime(2026),
        ),
        ScoreEntry(
          name: 'C',
          difficulty: 'Fácil',
          score: 14,
          total: 20,
          playedAt: DateTime(2026),
        ),
      ]..sort(ScoreEntry.compare);

      expect(entries.map((entry) => entry.name), ['B', 'C', 'A']);
    });
  });

  group('RankingService', () {
    test('salva, carrega e ordena as partidas', () async {
      final directory = await Directory.systemTemp.createTemp('quiz_ranking');
      final file = File(
        '${directory.path}${Platform.pathSeparator}ranking.json',
      );
      final service = RankingService(file: file);

      try {
        expect(await service.load(), isEmpty);

        await service.add(
          ScoreEntry(
            name: 'Ana',
            difficulty: 'Fácil',
            score: 6,
            total: 10,
            playedAt: DateTime(2026, 11, 24, 10),
          ),
        );
        await service.add(
          ScoreEntry(
            name: 'Bruno',
            difficulty: 'Difícil',
            score: 9,
            total: 10,
            playedAt: DateTime(2026, 11, 24, 11),
          ),
        );

        final entries = await service.load();
        expect(entries, hasLength(2));
        expect(entries.first.name, 'Bruno');

        await service.clear();
        expect(await service.load(), isEmpty);
      } finally {
        if (await directory.exists()) {
          await directory.delete(recursive: true);
        }
      }
    });
  });
}
