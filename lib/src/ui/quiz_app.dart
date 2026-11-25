import '../data/question_bank.dart';
import '../models/difficulty.dart';
import '../models/score_entry.dart';
import '../models/topic.dart';
import '../services/quiz_engine.dart';
import '../services/ranking_service.dart';
import 'console.dart';

class QuizApp {
  QuizApp({QuizEngine? engine, RankingService? ranking, Terminal? terminal})
    : _engine = engine ?? QuizEngine(bank: questionBank),
      _ranking = ranking ?? RankingService(),
      _terminal = terminal ?? Terminal();

  final QuizEngine _engine;
  final RankingService _ranking;
  final Terminal _terminal;

  static const List<String> _letters = ['A', 'B', 'C', 'D'];

  Future<void> run() async {
    try {
      _showWelcome();

      while (true) {
        _showMainMenu();
        final choice = _terminal.readMenuOption('Escolha uma opção: ', [
          '1',
          '2',
          '3',
        ]);

        if (choice == '1') {
          await _play();
        } else if (choice == '2') {
          await _showRanking();
        } else {
          _showFarewell();
          return;
        }
      }
    } on InputClosedException {
      _terminal.blank();
      _terminal.line(_terminal.yellow('Entrada encerrada. Até a próxima!'));
    }
  }

  void _showWelcome() {
    _terminal.blank();
    _terminal.banner(
      'QUIZ DE PROGRAMAÇÃO',
      subtitle: 'Desafio 2 - Trilhas de Programação',
    );
    _terminal.line('Teste seus conhecimentos em:');
    _terminal.line(
      _terminal.cyan(
        'Linguagens: JavaScript, Java, Kotlin, Dart, Swift',
      ),
    );
    _terminal.line(
      _terminal.cyan(
        'Bibliotecas/Frameworks: React, React Native, Flutter',
      ),
    );
    _terminal.blank();
    _terminal.line(
      'Banco com ${questionBank.length} perguntas, cada uma com 4 alternativas (A-D).',
    );
    _terminal.line(
      'Cada partida tem ${QuizEngine.questionsPerQuiz} perguntas sorteadas sem repetir.',
    );
    _terminal.line(
      'Escolha a área (todas, linguagens ou bibliotecas) e o nível de dificuldade.',
    );
    _terminal.line(
      _terminal.dim('Fique tranquilo: você pode jogar quantas vezes quiser.'),
    );
    _terminal.blank();
  }

  void _showMainMenu() {
    _terminal.line(_terminal.bold('MENU PRINCIPAL'));
    _terminal.line('  [1] Jogar');
    _terminal.line('  [2] Ver ranking');
    _terminal.line('  [3] Sair');
    _terminal.blank();
  }

  Future<void> _play() async {
    _terminal.blank();
    _terminal.line(_terminal.bold('NOVO JOGO'));

    final name = _terminal.readRequiredText(
      'Nome do jogador: ',
      emptyMessage: 'O nome não pode ficar vazio.',
    );

    var playAgain = true;

    while (playAgain) {
      final difficulty = _chooseDifficulty();
      final category = _chooseCategory();
      final questions = _engine.buildQuiz(
        difficulty: difficulty,
        category: category,
      );

      if (questions.isEmpty) {
        _terminal.line(
          _terminal.red('Não há perguntas disponíveis para essa configuração.'),
        );
        return;
      }

      final difficultyLabel = difficulty?.label ?? 'Misto';
      final categoryLabel = category?.label ?? 'Todas as áreas';

      _terminal.blank();
      _terminal.line(_terminal.cyan('Boa sorte, $name!'));
      _terminal.line(
        'Dificuldade: ${_terminal.bold(difficultyLabel)}  |  '
        'Área: ${_terminal.bold(categoryLabel)}  |  '
        'Perguntas: ${questions.length}',
      );
      _terminal.blank();

      var score = 0;

      for (var index = 0; index < questions.length; index++) {
        final presented = questions[index];
        _showQuestion(index + 1, questions.length, presented);

        final answerIndex = _readAnswer();
        final isCorrect = answerIndex == presented.correctIndex;

        if (isCorrect) {
          score++;
          _terminal.line(
            _terminal.green('Correto! ${presented.question.explanation}'),
          );
        } else {
          _terminal.line(_terminal.red('Incorreto.'));
          _terminal.line(
            'A resposta certa era '
            '${_letters[presented.correctIndex]}) ${presented.correctOption}',
          );
          _terminal.line(_terminal.dim(presented.question.explanation));
        }

        _terminal.blank();
      }

      final entry = ScoreEntry(
        name: name,
        difficulty: difficultyLabel,
        score: score,
        total: questions.length,
        playedAt: DateTime.now(),
      );

      await _ranking.add(entry);
      _showResult(entry);

      playAgain = _terminal.confirm('Jogar novamente? (s/n): ');
      _terminal.blank();
    }
  }

  Difficulty? _chooseDifficulty() {
    _terminal.blank();
    _terminal.line(_terminal.bold('Escolha a dificuldade:'));
    _terminal.line('  [1] Fácil');
    _terminal.line('  [2] Intermediário');
    _terminal.line('  [3] Difícil');
    _terminal.line('  [4] Misto (todas as dificuldades)');
    _terminal.blank();

    final choice = _terminal.readMenuOption('Dificuldade: ', [
      '1',
      '2',
      '3',
      '4',
    ]);

    return switch (choice) {
      '1' => Difficulty.facil,
      '2' => Difficulty.intermediario,
      '3' => Difficulty.dificil,
      _ => null,
    };
  }

  TopicCategory? _chooseCategory() {
    _terminal.blank();
    _terminal.line(_terminal.bold('Escolha a área:'));
    _terminal.line('  [1] Todas as tecnologias');
    _terminal.line('  [2] Somente linguagens');
    _terminal.line('  [3] Somente bibliotecas e frameworks');
    _terminal.blank();

    final choice = _terminal.readMenuOption('Área: ', ['1', '2', '3']);

    return switch (choice) {
      '2' => TopicCategory.linguagem,
      '3' => TopicCategory.biblioteca,
      _ => null,
    };
  }

  void _showQuestion(int number, int total, PresentedQuestion presented) {
    final question = presented.question;

    _terminal.line(_terminal.dim('-' * 62));
    _terminal.line(
      '${_terminal.bold('Pergunta $number/$total')}  '
      '${_terminal.magenta('[${question.topic.displayLabel}]')}  '
      '${_terminal.yellow('(${question.difficulty.label})')}',
    );
    _terminal.blank();
    _terminal.line(question.statement);
    _terminal.blank();

    for (var index = 0; index < presented.options.length; index++) {
      _terminal.line('  ${_letters[index]}) ${presented.options[index]}');
    }

    _terminal.blank();
  }

  int _readAnswer() {
    while (true) {
      final value = _terminal
          .readRequiredText(
            'Sua resposta: ',
            emptyMessage: 'Digite uma alternativa de A a D.',
          )
          .toUpperCase();

      final index = _letters.indexOf(value);
      if (index != -1) return index;

      _terminal.line(
        _terminal.red('Alternativa inválida. Digite A, B, C ou D.'),
      );
    }
  }

  void _showResult(ScoreEntry entry) {
    final percent = entry.percentage;

    _terminal.line(_terminal.cyan('=' * 62));
    _terminal.line(_terminal.bold('RESULTADO FINAL'));
    _terminal.line('Jogador: ${entry.name}');
    _terminal.line('Dificuldade: ${entry.difficulty}');
    _terminal.line(
      'Acertos: ${_terminal.green('${entry.score} de ${entry.total}')} '
      '(${percent.toStringAsFixed(0)}%)',
    );
    _terminal.blank();
    _terminal.line(_performanceMessage(percent));
    _terminal.line(_terminal.cyan('=' * 62));
    _terminal.line(_terminal.dim('Sua pontuação foi salva no ranking.'));
    _terminal.blank();
  }

  String _performanceMessage(double percent) {
    if (percent >= 90) {
      return _terminal.green(
        'Excelente! Você é praticamente uma referência em programação!',
      );
    }
    if (percent >= 70) {
      return _terminal.green(
        'Muito bom! Seu conhecimento está bem acima da média.',
      );
    }
    if (percent >= 50) {
      return _terminal.yellow(
        'Bom trabalho! Continue praticando para mandar ainda melhor.',
      );
    }
    if (percent > 0) {
      return _terminal.yellow(
        'Você está no caminho. Revise os temas e tente novamente!',
      );
    }
    return _terminal.red(
      'Não desanime! Todo grande programador começou errando. Tente de novo!',
    );
  }

  Future<void> _showRanking() async {
    final entries = await _ranking.load();

    _terminal.blank();
    _terminal.banner('RANKING DE JOGADORES');

    if (entries.isEmpty) {
      _terminal.line('Nenhuma partida registrada ainda. Jogue a primeira!');
      _terminal.blank();
      return;
    }

    final top = entries.take(10).toList();

    _terminal.line(
      _terminal.dim('Mostrando ${top.length} de ${entries.length} partida(s).'),
    );
    _terminal.blank();

    for (var index = 0; index < top.length; index++) {
      final entry = top[index];
      final position = '${index + 1}º'.padLeft(4);
      final name = _shorten(entry.name, 18).padRight(18);
      final difficulty = entry.difficulty.padRight(13);
      final score = '${entry.score}/${entry.total}'.padLeft(5);
      final percent = '${entry.percentage.toStringAsFixed(0)}%'.padLeft(4);

      _terminal.line(
        '$position  $name  $difficulty  $score  $percent  '
        '${_terminal.dim(entry.formattedPlayedAt)}',
      );
    }

    _terminal.blank();
    final clear = _terminal.confirm('Deseja limpar todo o ranking? (s/n): ');

    if (clear) {
      await _ranking.clear();
      _terminal.line(_terminal.green('Ranking apagado com sucesso.'));
    }

    _terminal.blank();
  }

  String _shorten(String value, int maxLength) {
    if (value.length <= maxLength) return value;
    return '${value.substring(0, maxLength - 3)}...';
  }

  void _showFarewell() {
    _terminal.blank();
    _terminal.line(_terminal.cyan('Obrigado por jogar! Até a próxima.'));
    _terminal.blank();
  }
}
