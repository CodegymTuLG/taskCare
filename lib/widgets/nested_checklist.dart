import 'package:flutter/material.dart';
import '../models/checklist_item.dart';

class NestedChecklist extends StatefulWidget {
  final List<ChecklistItem> items;
  final Function(ChecklistItem) onToggle;
  final Function(ChecklistItem, String) onAddChild;
  final Function(ChecklistItem) onDelete;
  final int maxDepth;

  const NestedChecklist({
    super.key,
    required this.items,
    required this.onToggle,
    required this.onAddChild,
    required this.onDelete,
    this.maxDepth = 3,
  });

  @override
  State<NestedChecklist> createState() => _NestedChecklistState();
}

class _NestedChecklistState extends State<NestedChecklist> {
  final Set<String> _expandedItems = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.items.map((item) => _buildChecklistItem(item, 0)).toList(),
    );
  }

  Widget _buildChecklistItem(ChecklistItem item, int depth) {
    final hasChildren = item.children != null && item.children!.isNotEmpty;
    final isExpanded = _expandedItems.contains(item.id);
    final canAddChild = depth < widget.maxDepth;

    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(
            left: depth * 20.0,
            bottom: 8,
          ),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: item.isCompleted ? Colors.green.shade50 : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: item.isCompleted ? Colors.green.shade200 : Colors.grey.shade300,
            ),
          ),
          child: Row(
            children: [
              // Expand/collapse button
              if (hasChildren)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isExpanded) {
                        _expandedItems.remove(item.id);
                      } else {
                        _expandedItems.add(item.id);
                      }
                    });
                  },
                  child: Icon(
                    isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                    size: 20,
                  ),
                )
              else
                const SizedBox(width: 20),

              const SizedBox(width: 8),

              // Checkbox
              GestureDetector(
                onTap: () => widget.onToggle(item),
                child: Icon(
                  item.isCompleted ? Icons.check_box : Icons.check_box_outline_blank,
                  color: item.isCompleted ? Colors.green : Colors.grey,
                  size: 24,
                ),
              ),

              const SizedBox(width: 12),

              // Title
              Expanded(
                child: Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 15,
                    decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                    color: item.isCompleted ? Colors.grey : Colors.black87,
                  ),
                ),
              ),

              // Add child button
              if (canAddChild)
                IconButton(
                  icon: const Icon(Icons.add, size: 18),
                  onPressed: () => _showAddSubtaskDialog(item),
                  tooltip: 'Add subtask',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),

              const SizedBox(width: 8),

              // Delete button
              IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: () => widget.onDelete(item),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),

        // Children
        if (hasChildren && isExpanded)
          ...item.children!.map((child) => _buildChecklistItem(child, depth + 1)),
      ],
    );
  }

  void _showAddSubtaskDialog(ChecklistItem parent) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Subtask'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter subtask title...',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                widget.onAddChild(parent, controller.text.trim());
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
