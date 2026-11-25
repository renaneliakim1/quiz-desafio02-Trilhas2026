import 'dart:convert';
import 'dart:io';

class InputClosedException implements Exception {
  const InputClosedException();
}

class Terminal {
  Terminal({bool? ansiEnabled})
    : _ansiEnabled = ansiEnabled ?? stdout.supportsAnsiEscapes {
    try {
      stdout.encoding = utf8;
    } catch (_) {
      // Alguns terminais não permitem alterar a codificação.
    }
  }

  final bool _ansiEnabled;

  String _wrap(String code, String text) {
    return _ansiEnabled ? '$code$text\x1B[0m' : text;
  }

  String bold(String text) => _wrap('\x1B[1m', text);
  String dim(String text) => _wrap('\x1B[2m', text);
  String red(String text) => _wrap('\x1B[31m', text);
  String green(String text) => _wrap('\x1B[32m', text);
  String yellow(String text) => _wrap('\x1B[33m', text);
  String blue(String text) => _wrap('\x1B[34m', text);
  String magenta(String text) => _wrap('\x1B[35m', text);
  String cyan(String text) => _wrap('\x1B[36m', text);

  void line([String text = '']) => stdout.writeln(text);
  void blank() => stdout.writeln();

  void banner(String title, {String? subtitle}) {
    const width = 62;
    line(cyan('=' * width));
    line(cyan(bold('  $title')));
    if (subtitle != null && subtitle.isNotEmpty) {
      line(cyan('  $subtitle'));
    }
    line(cyan('=' * width));
  }

  String? readLine(String prompt) {
    stdout.write(prompt);
    return stdin.readLineSync(encoding: utf8);
  }

  String readRequiredText(
    String prompt, {
    String emptyMessage = 'Por favor, digite algo.',
  }) {
    while (true) {
      final value = readLine(prompt)?.trim();

      if (value == null) throw const InputClosedException();
      if (value.isNotEmpty) return value;

      line(red(emptyMessage));
    }
  }

  String readMenuOption(
    String prompt,
    List<String> validOptions, {
    String invalidMessage = 'Opção inválida. Tente novamente.',
  }) {
    while (true) {
      final value = readRequiredText(prompt).toLowerCase();
      if (validOptions.contains(value)) return value;
      line(red(invalidMessage));
    }
  }

  bool confirm(String prompt) {
    while (true) {
      final value = readRequiredText(prompt).toLowerCase();
      if (value == 's' || value == 'sim') return true;
      if (value == 'n' || value == 'nao' || value == 'não') return false;
      line(red('Responda com s (sim) ou n (não).'));
    }
  }
}
