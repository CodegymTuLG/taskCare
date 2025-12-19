import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../models/todo.dart';
import '../models/tag.dart';

class StorageService {
  static const String _dataFileName = 'taskcare_data.json';

  File? _dataFile;
  Map<String, dynamic> _data = {};

  Future<void> init() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      _dataFile = File('${directory.path}/$_dataFileName');

      if (await _dataFile!.exists()) {
        final content = await _dataFile!.readAsString();
        if (content.isNotEmpty) {
          _data = jsonDecode(content) as Map<String, dynamic>;
        }
      } else {
        _data = {
          'todos': [],
          'tags': [],
          'fontScale': 1.0,
        };
        await _saveToFile();
      }
      debugPrint('StorageService initialized: ${_dataFile!.path}');
    } catch (e) {
      debugPrint('Error initializing storage: $e');
      _data = {
        'todos': [],
        'tags': [],
        'fontScale': 1.0,
      };
    }
  }

  Future<void> _saveToFile() async {
    if (_dataFile == null) return;
    try {
      final jsonString = const JsonEncoder.withIndent('  ').convert(_data);
      await _dataFile!.writeAsString(jsonString, flush: true);
      debugPrint('Data saved to file successfully');
    } catch (e) {
      debugPrint('Error saving to file: $e');
    }
  }

  // Todos
  Future<void> saveTodos(List<Todo> todos) async {
    try {
      _data['todos'] = todos.map((todo) => todo.toJson()).toList();
      await _saveToFile();
    } catch (e) {
      debugPrint('Error saving todos: $e');
    }
  }

  List<Todo> loadTodos() {
    try {
      final todosList = _data['todos'] as List<dynamic>? ?? [];
      return todosList
          .map((json) => Todo.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error loading todos: $e');
      return [];
    }
  }

  // Tags
  Future<void> saveTags(List<Tag> tags) async {
    try {
      _data['tags'] = tags.map((tag) => tag.toJson()).toList();
      await _saveToFile();
    } catch (e) {
      debugPrint('Error saving tags: $e');
    }
  }

  List<Tag> loadTags() {
    try {
      final tagsList = _data['tags'] as List<dynamic>? ?? [];
      return tagsList
          .map((json) => Tag.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error loading tags: $e');
      return [];
    }
  }

  // Font scale
  Future<void> saveFontScale(double scale) async {
    try {
      _data['fontScale'] = scale;
      await _saveToFile();
    } catch (e) {
      debugPrint('Error saving font scale: $e');
    }
  }

  double loadFontScale() {
    try {
      return (_data['fontScale'] as num?)?.toDouble() ?? 1.0;
    } catch (e) {
      debugPrint('Error loading font scale: $e');
      return 1.0;
    }
  }

  // Clear all data
  Future<void> clear() async {
    _data = {
      'todos': [],
      'tags': [],
      'fontScale': 1.0,
    };
    await _saveToFile();
  }

  // Get file path for debugging
  String? getFilePath() => _dataFile?.path;

  Future<void> close() async {
    // Nothing to close for file-based storage
  }
}
