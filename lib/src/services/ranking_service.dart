import 'dart:convert';
import 'dart:io';

import '../models/score_entry.dart';

class RankingService {
  RankingService({File? file}) : _file = file ?? File('ranking.json');

  final File _file;

  String get filePath => _file.path;

  Future<List<ScoreEntry>> load() async {
    try {
      if (!await _file.exists()) return [];

      final content = await _file.readAsString();
      if (content.trim().isEmpty) return [];

      final decoded = jsonDecode(content);
      if (decoded is! List) return [];

      final entries = <ScoreEntry>[
        for (final item in decoded)
          if (item is Map<String, dynamic>) ScoreEntry.fromJson(item),
      ];

      entries.sort(ScoreEntry.compare);
      return entries;
    } catch (_) {
      return [];
    }
  }

  Future<void> add(ScoreEntry entry) async {
    final entries = await load();
    entries.add(entry);
    entries.sort(ScoreEntry.compare);
    await _save(entries);
  }

  Future<void> clear() async {
    try {
      if (await _file.exists()) {
        await _file.delete();
      }
    } catch (_) {
      // Se não for possível apagar o arquivo, o ranking permanece intacto.
    }
  }

  Future<void> _save(List<ScoreEntry> entries) async {
    final data = [for (final entry in entries) entry.toJson()];
    await _file.writeAsString(const JsonEncoder.withIndent('  ').convert(data));
  }
}
