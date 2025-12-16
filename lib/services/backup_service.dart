import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/todo.dart';
import '../models/tag.dart';

class BackupService {
  static Future<String> exportData({
    required List<Todo> todos,
    required List<Tag> tags,
  }) async {
    final data = {
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'todos': todos.map((t) => t.toJson()).toList(),
      'tags': tags.map((t) => t.toJson()).toList(),
    };

    final jsonString = const JsonEncoder.withIndent('  ').convert(data);

    // Save to file
    final directory = await getApplicationDocumentsDirectory();
    final fileName = 'taskcare_backup_${DateTime.now().millisecondsSinceEpoch}.json';
    final file = File('${directory.path}/$fileName');
    await file.writeAsString(jsonString);

    return file.path;
  }

  static Future<void> shareBackup({
    required List<Todo> todos,
    required List<Tag> tags,
  }) async {
    final filePath = await exportData(todos: todos, tags: tags);
    await Share.shareXFiles(
      [XFile(filePath)],
      subject: 'TaskCare Backup',
      text: 'TaskCare data backup',
    );
  }

  static Future<Map<String, dynamic>?> importData(String jsonString) async {
    try {
      final data = jsonDecode(jsonString) as Map<String, dynamic>;

      // Validate structure
      if (!data.containsKey('todos')) {
        return null;
      }

      final List<Todo> todos = (data['todos'] as List<dynamic>)
          .map((json) => Todo.fromJson(json as Map<String, dynamic>))
          .toList();

      List<Tag> tags = [];
      if (data.containsKey('tags')) {
        tags = (data['tags'] as List<dynamic>)
            .map((json) => Tag.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      return {
        'todos': todos,
        'tags': tags,
      };
    } catch (e) {
      return null;
    }
  }

  static Future<String> getBackupFolder() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<List<FileSystemEntity>> getBackupFiles() async {
    final directory = await getApplicationDocumentsDirectory();
    final files = directory.listSync()
        .where((f) => f.path.endsWith('.json') && f.path.contains('taskcare_backup'))
        .toList();
    files.sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));
    return files;
  }

  static Future<void> deleteBackup(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
