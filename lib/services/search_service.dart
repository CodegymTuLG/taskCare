import '../models/todo.dart';
import '../models/checklist_item.dart';

class SearchService {
  static List<Todo> search(List<Todo> todos, String query) {
    if (query.trim().isEmpty) return todos;

    final lowerQuery = query.toLowerCase();
    return todos.where((todo) {
      if (todo.title.toLowerCase().contains(lowerQuery)) return true;
      if (todo.description.toLowerCase().contains(lowerQuery)) return true;
      if (_searchChecklist(todo.checklist, lowerQuery)) return true;
      return false;
    }).toList();
  }

  static bool _searchChecklist(List<ChecklistItem> items, String query) {
    for (var item in items) {
      if (item.title.toLowerCase().contains(query)) return true;
      if (item.children != null && _searchChecklist(item.children!, query)) {
        return true;
      }
    }
    return false;
  }
}
