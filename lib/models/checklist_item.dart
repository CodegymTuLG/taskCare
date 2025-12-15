import 'package:uuid/uuid.dart';

class ChecklistItem {
  String id;
  String title;
  bool isCompleted;
  List<ChecklistItem>? children; // For Phase 5: Nested subtasks

  ChecklistItem({
    String? id,
    required this.title,
    this.isCompleted = false,
    this.children,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'isCompleted': isCompleted,
        'children': children?.map((child) => child.toJson()).toList(),
      };

  factory ChecklistItem.fromJson(Map<String, dynamic> json) => ChecklistItem(
        id: json['id'] as String,
        title: json['title'] as String,
        isCompleted: json['isCompleted'] as bool? ?? false,
        children: (json['children'] as List<dynamic>?)
            ?.map((item) => ChecklistItem.fromJson(item as Map<String, dynamic>))
            .toList(),
      );

  // Calculate completion percentage including nested children
  double getCompletionPercentage() {
    final stats = _getCompletionStats();
    return stats.$1 > 0 ? stats.$2 / stats.$1 : 0.0;
  }

  // Returns (totalItems, completedItems)
  (int, int) _getCompletionStats() {
    int total = 1;
    int completed = isCompleted ? 1 : 0;

    if (children != null && children!.isNotEmpty) {
      for (var child in children!) {
        final childStats = child._getCompletionStats();
        total += childStats.$1;
        completed += childStats.$2;
      }
    }

    return (total, completed);
  }

  // Get maximum depth of nested structure
  int getTotalDepth() {
    if (children == null || children!.isEmpty) return 1;
    return 1 + children!.map((c) => c.getTotalDepth()).reduce((a, b) => a > b ? a : b);
  }
}
