import 'checklist_item.dart';
import 'package:uuid/uuid.dart';

class Todo {
  String id;
  String title;
  String description;
  bool isCompleted;
  String priority; // Internal: 'Thấp', 'Thường', 'Cao', 'Khẩn cấp'
  DateTime createdAt;
  DateTime? dueDate;
  String? category;
  List<ChecklistItem> checklist;
  String? imagePath; // Path to attached image
  List<String> tagIds; // List of tag IDs

  Todo({
    String? id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    this.priority = 'Thường',
    required this.createdAt,
    this.dueDate,
    this.category,
    List<ChecklistItem>? checklist,
    this.imagePath,
    List<String>? tagIds,
  })  : id = id ?? const Uuid().v4(),
        checklist = checklist ?? [],
        tagIds = tagIds ?? [];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'isCompleted': isCompleted,
        'priority': priority,
        'createdAt': createdAt.toIso8601String(),
        'dueDate': dueDate?.toIso8601String(),
        'category': category,
        'checklist': checklist.map((item) => item.toJson()).toList(),
        'imagePath': imagePath,
        'tagIds': tagIds,
      };

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String? ?? '',
        isCompleted: json['isCompleted'] as bool? ?? false,
        priority: json['priority'] as String? ?? 'Thường',
        createdAt: DateTime.parse(json['createdAt'] as String),
        dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate'] as String) : null,
        category: json['category'] as String?,
        checklist: (json['checklist'] as List<dynamic>?)
            ?.map((item) => ChecklistItem.fromJson(item as Map<String, dynamic>))
            .toList(),
        imagePath: json['imagePath'] as String?,
        tagIds: (json['tagIds'] as List<dynamic>?)?.map((e) => e as String).toList(),
      );
}
