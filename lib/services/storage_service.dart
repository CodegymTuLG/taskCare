import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/todo.dart';

class StorageService {
  static const String _todosBoxName = 'todos';
  static const String _todosKey = 'todos_list';
  static const String _versionKey = 'schema_version';
  static const int _currentVersion = 2;

  Box? _box;

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_todosBoxName);
    await _migrateIfNeeded();
  }

  Future<void> _migrateIfNeeded() async {
    final version = _box!.get(_versionKey, defaultValue: 1) as int;
    if (version < _currentVersion) {
      await _migrateFromV1();
      await _box!.put(_versionKey, _currentVersion);
    }
  }

  Future<void> _migrateFromV1() async {
    final rawData = _box!.get(_todosKey);
    if (rawData == null || rawData is! List) return;

    final migratedTodos = <Map<String, dynamic>>[];

    for (var json in rawData) {
      if (json is! Map) continue;

      final migratedTodo = <String, dynamic>{
        'id': json['id'] ?? const Uuid().v4(),
        'title': json['title'],
        'description': json['description'] ?? '',
        'isCompleted': json['isCompleted'] ?? false,
        'priority': json['priority'] ?? 'Thường',
        'createdAt': json['createdAt'] ?? DateTime.now().toIso8601String(),
        'dueDate': null,
        'category': null,
      };

      // Migrate checklist items
      if (json['checklist'] is List) {
        final checklistItems = <Map<String, dynamic>>[];
        for (var item in (json['checklist'] as List)) {
          if (item is Map) {
            checklistItems.add({
              'id': const Uuid().v4(),
              'title': item['title'] ?? '',
              'isCompleted': item['isCompleted'] ?? false,
              'children': null,
            });
          }
        }
        migratedTodo['checklist'] = checklistItems;
      } else {
        migratedTodo['checklist'] = [];
      }

      migratedTodos.add(migratedTodo);
    }

    await _box!.put(_todosKey, migratedTodos);
  }

  Future<void> saveTodos(List<Todo> todos) async {
    try {
      final jsonList = todos.map((todo) => todo.toJson()).toList();
      await _box!.put(_todosKey, jsonList);
      // Flush to ensure data is written to disk immediately
      await _box!.flush();
    } catch (e) {
      // Log error but don't rethrow to avoid debugger pause
      print('Error saving todos: $e');
    }
  }

  List<Todo> loadTodos() {
    try {
      final jsonList = _box!.get(_todosKey, defaultValue: []) as List;
      return jsonList
          .map((json) => Todo.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error loading todos: $e');
      return [];
    }
  }

  Future<void> clear() async {
    await _box!.clear();
  }

  Future<void> close() async {
    await _box?.close();
  }
}
