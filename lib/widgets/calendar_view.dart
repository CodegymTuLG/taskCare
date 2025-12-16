import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/todo.dart';

class CalendarViewWidget extends StatefulWidget {
  final List<Todo> todos;
  final String Function(String) translate;
  final Color themeColor;
  final bool isDarkMode;
  final Function(Todo) onTodoTap;

  const CalendarViewWidget({
    super.key,
    required this.todos,
    required this.translate,
    required this.themeColor,
    required this.isDarkMode,
    required this.onTodoTap,
  });

  @override
  State<CalendarViewWidget> createState() => _CalendarViewWidgetState();
}

class _CalendarViewWidgetState extends State<CalendarViewWidget> {
  late DateTime _selectedDate;
  late DateTime _focusedMonth;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _focusedMonth = DateTime.now();
  }

  List<Todo> _getTodosForDate(DateTime date) {
    return widget.todos.where((todo) {
      if (todo.dueDate == null) return false;
      return todo.dueDate!.year == date.year &&
          todo.dueDate!.month == date.month &&
          todo.dueDate!.day == date.day;
    }).toList();
  }

  bool _hasTasksOnDate(DateTime date) {
    return _getTodosForDate(date).isNotEmpty;
  }

  int _getIncompleteTasks(DateTime date) {
    return _getTodosForDate(date).where((t) => !t.isCompleted).length;
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.isDarkMode ? Colors.grey.shade900 : Colors.white;
    final textColor = widget.isDarkMode ? Colors.white : Colors.black87;
    final subTextColor = widget.isDarkMode ? Colors.white54 : Colors.grey.shade600;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: widget.themeColor.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Month navigation
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _focusedMonth = DateTime(
                        _focusedMonth.year,
                        _focusedMonth.month - 1,
                      );
                    });
                  },
                  icon: Icon(Icons.chevron_left, color: textColor),
                ),
                Text(
                  DateFormat('MMMM yyyy').format(_focusedMonth),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _focusedMonth = DateTime(
                        _focusedMonth.year,
                        _focusedMonth.month + 1,
                      );
                    });
                  },
                  icon: Icon(Icons.chevron_right, color: textColor),
                ),
              ],
            ),
          ),
          // Week day headers
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((day) {
                return SizedBox(
                  width: 40,
                  child: Center(
                    child: Text(
                      day,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: subTextColor,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          // Calendar grid
          _buildCalendarGrid(textColor, subTextColor),
          const Divider(),
          // Tasks for selected date
          _buildTasksForSelectedDate(textColor, subTextColor),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(Color textColor, Color subTextColor) {
    final firstDayOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final lastDayOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday % 7;
    final daysInMonth = lastDayOfMonth.day;

    final days = <Widget>[];

    // Empty cells for days before month starts
    for (var i = 0; i < firstWeekday; i++) {
      days.add(const SizedBox(width: 40, height: 40));
    }

    // Days of the month
    for (var day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_focusedMonth.year, _focusedMonth.month, day);
      final isSelected = _selectedDate.year == date.year &&
          _selectedDate.month == date.month &&
          _selectedDate.day == date.day;
      final isToday = DateTime.now().year == date.year &&
          DateTime.now().month == date.month &&
          DateTime.now().day == date.day;
      final hasTasks = _hasTasksOnDate(date);
      final incompleteTasks = _getIncompleteTasks(date);

      days.add(
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = date;
            });
          },
          child: Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isSelected
                  ? widget.themeColor
                  : isToday
                      ? widget.themeColor.withValues(alpha: 0.2)
                      : null,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  day.toString(),
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : isToday
                            ? widget.themeColor
                            : textColor,
                    fontWeight: isToday || isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                if (hasTasks && !isSelected)
                  Positioned(
                    bottom: 4,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: incompleteTasks > 0 ? Colors.red : Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        alignment: WrapAlignment.start,
        children: days,
      ),
    );
  }

  Widget _buildTasksForSelectedDate(Color textColor, Color subTextColor) {
    final todosForDate = _getTodosForDate(_selectedDate);
    final isToday = _selectedDate.year == DateTime.now().year &&
        _selectedDate.month == DateTime.now().month &&
        _selectedDate.day == DateTime.now().day;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.event, color: widget.themeColor, size: 20),
              const SizedBox(width: 8),
              Text(
                isToday
                    ? widget.translate('today')
                    : DateFormat('EEEE, d MMM').format(_selectedDate),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.themeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${todosForDate.length}',
                  style: TextStyle(
                    color: widget.themeColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (todosForDate.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.event_available,
                      size: 48,
                      color: subTextColor.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.translate('no_tasks_today'),
                      style: TextStyle(color: subTextColor),
                    ),
                  ],
                ),
              ),
            )
          else
            ...todosForDate.map((todo) => _buildTaskItem(todo, textColor, subTextColor)),
        ],
      ),
    );
  }

  Widget _buildTaskItem(Todo todo, Color textColor, Color subTextColor) {
    return GestureDetector(
      onTap: () => widget.onTodoTap(todo),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: widget.isDarkMode
              ? Colors.grey.shade800
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border(
            left: BorderSide(
              color: todo.isCompleted ? Colors.green : _getPriorityColor(todo.priority),
              width: 3,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: todo.isCompleted ? Colors.green : Colors.transparent,
                border: Border.all(
                  color: todo.isCompleted ? Colors.green : _getPriorityColor(todo.priority),
                  width: 2,
                ),
              ),
              child: todo.isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todo.title,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w500,
                      decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  if (todo.dueDate != null)
                    Text(
                      DateFormat('HH:mm').format(todo.dueDate!),
                      style: TextStyle(
                        fontSize: 12,
                        color: subTextColor,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'Thấp':
        return Colors.green;
      case 'Cao':
        return Colors.orange;
      case 'Khẩn cấp':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}
