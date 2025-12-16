import 'dart:async';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'models/todo.dart';
import 'models/checklist_item.dart';
import 'models/category.dart';
import 'services/storage_service.dart';
import 'services/search_service.dart';
import 'services/notification_service.dart';
import 'services/biometric_service.dart';
import 'services/voice_input_service.dart';
import 'widgets/category_picker.dart';
import 'widgets/nested_checklist.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storageService = StorageService();
  await storageService.init();

  await NotificationService.init();
  await NotificationService.requestPermissions();

  runApp(MyApp(storageService: storageService));
}

class AppLocalizations {
  final String languageCode;

  AppLocalizations(this.languageCode);

  static final Map<String, Map<String, String>> _localizedValues = {
    'vi': {
      'app_title': 'Quản Lý Công Việc',
      'quick_add_hint': 'Thêm công việc nhanh...',
      'add_task_title': 'Thêm công việc mới',
      'title_label': 'Tiêu đề',
      'title_hint': 'Nhập tiêu đề công việc...',
      'description_label': 'Mô tả (tùy chọn)',
      'description_hint': 'Nhập mô tả...',
      'priority_label': 'Độ ưu tiên:',
      'priority_low': 'Thấp',
      'priority_normal': 'Thường',
      'priority_high': 'Cao',
      'priority_urgent': 'Khẩn cấp',
      'checklist_label': 'Checklist:',
      'checklist_add': 'Thêm mục',
      'checklist_hint': 'Nhập mục checklist...',
      'add_button': 'Thêm công việc',
      'added_snackbar': '✓ Đã thêm công việc!',
      'task_added': 'Đã thêm công việc mới!',
      'title_required': 'Vui lòng nhập tiêu đề công việc!',
      'deleted_snackbar': 'Đã xóa: ',
      'undo': 'Hoàn tác',
      'delete': 'Xóa',
      'sort_newest': 'Mới nhất',
      'sort_oldest': 'Cũ nhất',
      'sort_priority': 'Theo ưu tiên',
      'filter_all': 'Tất cả',
      'filter_incomplete': 'Chưa hoàn thành',
      'filter_complete': 'Hoàn thành',
      'filter_urgent': 'Khẩn cấp',
      'filter_high': 'Cao',
      'empty_all': 'Chưa có công việc nào\nGõ ở trên để thêm nhanh!',
      'empty_filter': 'Không có công việc ',
      'more_items': ' mục khác',
      'share': 'Chia sẻ',
      'share_task_title': 'Chia sẻ công việc',
      'share_completed': ' ✓ (Đã hoàn thành)',
      'share_checklist': 'Checklist:',
      'loading_data': 'Đang tải dữ liệu...',
      'storage_error': 'Không thể lưu dữ liệu',
      'category_label': 'Danh mục:',
      'category_work': 'Công việc',
      'category_personal': 'Cá nhân',
      'category_shopping': 'Mua sắm',
      'category_study': 'Học tập',
      'category_none': 'Không',
      'search_hint': 'Tìm kiếm...',
      'no_results': 'Không có kết quả',
      'due_date_label': 'Hạn chót:',
      'due_date_set': 'Đặt hạn chót',
      'due_in': 'Còn',
      'overdue': 'Quá hạn',
      'hours_short': 'giờ',
      'minutes_short': 'phút',
      'days_short': 'ngày',
      'voice_input': 'Nhập giọng nói',
      'voice_listening': 'Đang nghe...',
      'voice_not_available': 'Không hỗ trợ nhập giọng nói',
      'biometric_required': 'Xác thực để hoàn thành',
      'biometric_failed': 'Xác thực thất bại',
      'biometric_not_available': 'Thiết bị không hỗ trợ xác thực sinh trắc',
      'theme_color': 'Màu chủ đạo',
      'theme_blue': 'Xanh dương',
      'theme_green': 'Xanh lá',
      'theme_purple': 'Tím',
      'theme_orange': 'Cam',
      'theme_red': 'Đỏ',
      'theme_teal': 'Xanh ngọc',
    },
    'en': {
      'app_title': 'Task Manager',
      'quick_add_hint': 'Quick add task...',
      'add_task_title': 'Add New Task',
      'title_label': 'Title',
      'title_hint': 'Enter task title...',
      'description_label': 'Description (optional)',
      'description_hint': 'Enter description...',
      'priority_label': 'Priority:',
      'priority_low': 'Low',
      'priority_normal': 'Normal',
      'priority_high': 'High',
      'priority_urgent': 'Urgent',
      'checklist_label': 'Checklist:',
      'checklist_add': 'Add Item',
      'checklist_hint': 'Enter checklist item...',
      'add_button': 'Add Task',
      'added_snackbar': '✓ Task added!',
      'task_added': 'New task added!',
      'title_required': 'Please enter task title!',
      'deleted_snackbar': 'Deleted: ',
      'undo': 'Undo',
      'delete': 'Delete',
      'sort_newest': 'Newest',
      'sort_oldest': 'Oldest',
      'sort_priority': 'By Priority',
      'filter_all': 'All',
      'filter_incomplete': 'Incomplete',
      'filter_complete': 'Complete',
      'filter_urgent': 'Urgent',
      'filter_high': 'High',
      'empty_all': 'No tasks yet\nType above to add quickly!',
      'empty_filter': 'No tasks for ',
      'more_items': ' more',
      'share': 'Share',
      'share_task_title': 'Share Task',
      'share_completed': ' ✓ (Completed)',
      'share_checklist': 'Checklist:',
      'loading_data': 'Loading...',
      'storage_error': 'Storage error',
      'category_label': 'Category:',
      'category_work': 'Work',
      'category_personal': 'Personal',
      'category_shopping': 'Shopping',
      'category_study': 'Study',
      'category_none': 'None',
      'search_hint': 'Search...',
      'no_results': 'No results',
      'due_date_label': 'Due Date:',
      'due_date_set': 'Set due date',
      'due_in': 'Due in',
      'overdue': 'Overdue',
      'hours_short': 'h',
      'minutes_short': 'm',
      'days_short': 'd',
      'voice_input': 'Voice input',
      'voice_listening': 'Listening...',
      'voice_not_available': 'Voice input not available',
      'biometric_required': 'Authenticate to complete',
      'biometric_failed': 'Authentication failed',
      'biometric_not_available': 'Biometric not supported',
      'theme_color': 'Theme Color',
      'theme_blue': 'Blue',
      'theme_green': 'Green',
      'theme_purple': 'Purple',
      'theme_orange': 'Orange',
      'theme_red': 'Red',
      'theme_teal': 'Teal',
    },
    'ja': {
      'app_title': 'タスク管理',
      'quick_add_hint': 'タスクをクイック追加...',
      'add_task_title': '新しいタスクを追加',
      'title_label': 'タイトル',
      'title_hint': 'タスクのタイトルを入力...',
      'description_label': '説明（オプション）',
      'description_hint': '説明を入力...',
      'priority_label': '優先度:',
      'priority_low': '低',
      'priority_normal': '通常',
      'priority_high': '高',
      'priority_urgent': '緊急',
      'checklist_label': 'チェックリスト:',
      'checklist_add': '項目を追加',
      'checklist_hint': 'チェックリスト項目を入力...',
      'add_button': 'タスクを追加',
      'added_snackbar': '✓ タスクを追加しました！',
      'task_added': '新しいタスクを追加しました！',
      'title_required': 'タスクのタイトルを入力してください！',
      'deleted_snackbar': '削除しました: ',
      'undo': '元に戻す',
      'delete': '削除',
      'sort_newest': '最新',
      'sort_oldest': '最古',
      'sort_priority': '優先度順',
      'filter_all': 'すべて',
      'filter_incomplete': '未完了',
      'filter_complete': '完了',
      'filter_urgent': '緊急',
      'filter_high': '高',
      'empty_all': 'まだタスクがありません\n上で入力してクイック追加！',
      'empty_filter': '該当するタスクがありません: ',
      'more_items': ' 件以上',
      'share': '共有',
      'share_task_title': 'タスクを共有',
      'share_completed': ' ✓ (完了)',
      'share_checklist': 'チェックリスト:',
      'loading_data': '読み込み中...',
      'storage_error': 'ストレージエラー',
      'category_label': 'カテゴリー:',
      'category_work': '仕事',
      'category_personal': '個人的',
      'category_shopping': '買い物',
      'category_study': '勉強',
      'category_none': 'なし',
      'search_hint': '検索...',
      'no_results': '結果なし',
      'due_date_label': '期限:',
      'due_date_set': '期限設定',
      'due_in': '残り',
      'overdue': '期限切れ',
      'hours_short': '時間',
      'minutes_short': '分',
      'days_short': '日',
      'voice_input': '音声入力',
      'voice_listening': '聞いています...',
      'voice_not_available': '音声入力は利用できません',
      'biometric_required': '完了するには認証が必要',
      'biometric_failed': '認証に失敗しました',
      'biometric_not_available': '生体認証はサポートされていません',
      'theme_color': 'テーマカラー',
      'theme_blue': '青',
      'theme_green': '緑',
      'theme_purple': '紫',
      'theme_orange': 'オレンジ',
      'theme_red': '赤',
      'theme_teal': 'ティール',
    },
  };

  String translate(String key) {
    return _localizedValues[languageCode]?[key] ?? key;
  }
}

class MyApp extends StatefulWidget {
  final StorageService storageService;

  const MyApp({super.key, required this.storageService});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _languageCode = 'vi';
  Color _themeColor = Colors.blue;

  void changeLanguage(String newLanguageCode) {
    setState(() {
      _languageCode = newLanguageCode;
    });
  }

  void changeThemeColor(Color newColor) {
    setState(() {
      _themeColor = newColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppLocalizations(_languageCode).translate('app_title'),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: _themeColor),
        useMaterial3: true,
      ),
      home: TodoHomePage(
        languageCode: _languageCode,
        onLanguageChange: changeLanguage,
        storageService: widget.storageService,
        themeColor: _themeColor,
        onThemeColorChange: changeThemeColor,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TodoHomePage extends StatefulWidget {
  final String languageCode;
  final Function(String) onLanguageChange;
  final StorageService storageService;
  final Color themeColor;
  final Function(Color) onThemeColorChange;

  const TodoHomePage({
    super.key,
    required this.languageCode,
    required this.onLanguageChange,
    required this.storageService,
    required this.themeColor,
    required this.onThemeColorChange,
  });

  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> with WidgetsBindingObserver {
  List<Todo> _todos = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _quickAddController = TextEditingController();
  final TextEditingController _checklistItemController = TextEditingController();
  final List<ChecklistItem> _tempChecklist = [];
  String _selectedPriority = 'Thường';
  String? _selectedCategory;
  DateTime? _selectedDueDate;
  String _filterStatus = 'Chưa hoàn thành';
  String _sortBy = 'Mới nhất';
  bool _isLoading = true;
  Timer? _saveTimer;
  late StorageService _storage;
  String _searchQuery = '';
  bool _isListening = false;

  AppLocalizations get _loc => AppLocalizations(widget.languageCode);

  String _getPriorityKey(String displayValue) {
    final viPriorities = ['Thấp', 'Thường', 'Cao', 'Khẩn cấp'];
    final enPriorities = ['Low', 'Normal', 'High', 'Urgent'];
    final jaPriorities = ['低', '通常', '高', '緊急'];

    if (viPriorities.contains(displayValue)) return displayValue;
    if (enPriorities.contains(displayValue)) return viPriorities[enPriorities.indexOf(displayValue)];
    if (jaPriorities.contains(displayValue)) return viPriorities[jaPriorities.indexOf(displayValue)];
    return 'Thường';
  }

  String _getLocalizedPriority(String viPriority) {
    final priorities = {'Thấp': 'priority_low', 'Thường': 'priority_normal', 'Cao': 'priority_high', 'Khẩn cấp': 'priority_urgent'};
    return _loc.translate(priorities[viPriority] ?? 'priority_normal');
  }

  String _getLocalizedFilter(String viFilter) {
    final filters = {
      'Tất cả': 'filter_all',
      'Chưa hoàn thành': 'filter_incomplete',
      'Hoàn thành': 'filter_complete',
      'Khẩn cấp': 'filter_urgent',
      'Cao': 'filter_high'
    };
    return _loc.translate(filters[viFilter] ?? 'filter_all');
  }

  String _getLocalizedSort(String viSort) {
    final sorts = {'Mới nhất': 'sort_newest', 'Cũ nhất': 'sort_oldest', 'Ưu tiên': 'sort_priority'};
    return _loc.translate(sorts[viSort] ?? 'sort_newest');
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _storage = widget.storageService;
    _loadTodos();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Save immediately when app goes to background or is closed
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      _saveTimer?.cancel();
      _storage.saveTodos(_todos);
    }
  }

  Future<void> _loadTodos() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final todos = _storage.loadTodos();
      setState(() {
        _todos = todos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_loc.translate('storage_error')),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _scheduleSave() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 300), () {
      _storage.saveTodos(_todos);
    });
  }

  Future<void> _startVoiceInput(TextEditingController controller) async {
    final isAvailable = await VoiceInputService.isAvailable();
    if (!isAvailable) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_loc.translate('voice_not_available')),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    setState(() {
      _isListening = true;
    });

    await VoiceInputService.startListening(
      onResult: (text) {
        setState(() {
          controller.text = text;
        });
      },
      localeId: VoiceInputService.getLocaleId(widget.languageCode),
    );
  }

  Future<void> _stopVoiceInput() async {
    await VoiceInputService.stopListening();
    setState(() {
      _isListening = false;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _saveTimer?.cancel();
    // Save one final time before disposing
    _storage.saveTodos(_todos);
    _titleController.dispose();
    _descriptionController.dispose();
    _quickAddController.dispose();
    _checklistItemController.dispose();
    super.dispose();
  }

  void _quickAddTodo() {
    if (_quickAddController.text.trim().isEmpty) return;

    setState(() {
      _todos.insert(
        0,
        Todo(
          title: _quickAddController.text.trim(),
          priority: 'Thường',
          createdAt: DateTime.now(),
        ),
      );
    });

    _scheduleSave();
    _quickAddController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_loc.translate('added_snackbar')),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 80, left: 20, right: 20),
      ),
    );
  }

  void _addTodo() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_loc.translate('title_required')),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final newTodo = Todo(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      priority: _selectedPriority,
      category: _selectedCategory,
      dueDate: _selectedDueDate,
      createdAt: DateTime.now(),
      checklist: List.from(_tempChecklist),
    );

    setState(() {
      _todos.insert(0, newTodo);
    });

    _scheduleSave();

    // Schedule notification if due date is set
    if (newTodo.dueDate != null) {
      NotificationService.scheduleTodoReminder(newTodo);
    }

    _titleController.clear();
    _descriptionController.clear();
    _selectedPriority = 'Thường';
    _selectedCategory = null;
    _selectedDueDate = null;
    _tempChecklist.clear();
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_loc.translate('task_added')),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _toggleTodo(int index) async {
    final todo = _todos[index];

    // If marking as complete, require biometric authentication
    if (!todo.isCompleted) {
      final authenticated = await BiometricService.authenticateToCompleteTask(todo.title);

      if (!authenticated) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_loc.translate('biometric_failed')),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
        }
        return;
      }
    }

    setState(() {
      _todos[index].isCompleted = !_todos[index].isCompleted;
    });
    _scheduleSave();

    // Cancel notification if completed, reschedule if uncompleted
    if (_todos[index].isCompleted) {
      NotificationService.cancelTodoReminder(_todos[index].id);
    } else if (_todos[index].dueDate != null) {
      NotificationService.scheduleTodoReminder(_todos[index]);
    }
  }

  void _deleteTodo(int index) {
    final todo = _todos[index];
    NotificationService.cancelTodoReminder(todo.id);

    setState(() {
      _todos.removeAt(index);
    });
    _scheduleSave();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_loc.translate('deleted_snackbar')}${todo.title}'),
        backgroundColor: Colors.orange,
        action: SnackBarAction(
          label: _loc.translate('undo'),
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              _todos.insert(index, todo);
            });
            _scheduleSave();
          },
        ),
      ),
    );
  }

  void _shareTodo(Todo todo) {
    String shareText = '${_loc.translate('share_task_title')}\n\n';
    shareText += '📋 ${todo.title}';

    if (todo.isCompleted) {
      shareText += _loc.translate('share_completed');
    }

    shareText += '\n🎯 ${_loc.translate('priority_label')} ${_getLocalizedPriority(todo.priority)}';

    if (todo.description.isNotEmpty) {
      shareText += '\n\n📝 ${todo.description}';
    }

    if (todo.checklist.isNotEmpty) {
      shareText += '\n\n${_loc.translate('share_checklist')}';
      for (var item in todo.checklist) {
        final checkbox = item.isCompleted ? '☑' : '☐';
        shareText += '\n$checkbox ${item.title}';
      }
    }

    Share.share(shareText, subject: todo.title);
  }

  void _showTodoDetail(Todo todo, int index) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header với màu gradient
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade600, Colors.blue.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => _toggleTodo(index),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2.5),
                          color: todo.isCompleted ? Colors.white : Colors.transparent,
                        ),
                        child: todo.isCompleted
                            ? Icon(Icons.check, color: Colors.blue.shade600, size: 20)
                            : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            todo.title,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _getLocalizedPriority(todo.priority),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              // Nội dung
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (todo.description.isNotEmpty) ...[
                        Row(
                          children: [
                            Icon(Icons.description, color: Colors.blue.shade600, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              _loc.translate('description_label'),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            todo.description,
                            style: const TextStyle(fontSize: 15, height: 1.5),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                      if (todo.checklist.isNotEmpty) ...[
                        Row(
                          children: [
                            Icon(Icons.checklist, color: Colors.blue.shade600, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              _loc.translate('checklist_label'),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Progress bar
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: todo.checklist.where((item) => item.isCompleted).length / todo.checklist.length,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Colors.green.shade400, Colors.green.shade600],
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '${((todo.checklist.where((item) => item.isCompleted).length / todo.checklist.length) * 100).toInt()}%',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ...todo.checklist.map((item) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
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
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      item.isCompleted = !item.isCompleted;
                                    });
                                    Navigator.pop(context);
                                    _showTodoDetail(todo, index);
                                  },
                                  child: Icon(
                                    item.isCompleted ? Icons.check_box : Icons.check_box_outline_blank,
                                    color: item.isCompleted ? Colors.green : Colors.grey,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
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
                              ],
                            ),
                          );
                        }),
                      ],
                    ],
                  ),
                ),
              ),
              // Footer với nút action
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _shareTodo(todo);
                        },
                        icon: const Icon(Icons.share),
                        label: Text(_loc.translate('share')),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _deleteTodo(index);
                        },
                        icon: const Icon(Icons.delete),
                        label: Text(_loc.translate('delete')),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddTodoDialog() {
    _titleController.clear();
    _descriptionController.clear();
    _selectedPriority = 'Thường';
    _selectedCategory = null;
    // Set default due date to tomorrow same time
    final now = DateTime.now();
    _selectedDueDate = DateTime(now.year, now.month, now.day + 1, now.hour, now.minute);
    _tempChecklist.clear();
    bool isDialogListening = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          final themeColor = widget.themeColor;
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.85,
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 50,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Title field
                      TextField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: _loc.translate('title_label'),
                          hintText: isDialogListening
                              ? _loc.translate('voice_listening')
                              : _loc.translate('title_hint'),
                          prefixIcon: const Icon(Icons.title),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Description field
                      TextField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: _loc.translate('description_label'),
                          hintText: _loc.translate('description_hint'),
                          prefixIcon: const Icon(Icons.description),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 8),
                      // Voice input button - shared for both fields
                      Center(
                        child: InkWell(
                          onTap: () async {
                            if (isDialogListening) {
                              await VoiceInputService.stopListening();
                              setModalState(() {
                                isDialogListening = false;
                              });
                            } else {
                              final isAvailable = await VoiceInputService.isAvailable();
                              if (!isAvailable) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(_loc.translate('voice_not_available')),
                                      backgroundColor: Colors.orange,
                                    ),
                                  );
                                }
                                return;
                              }
                              setModalState(() {
                                isDialogListening = true;
                              });
                              // Fill title first, then description
                              await VoiceInputService.startListening(
                                onResult: (text) {
                                  setModalState(() {
                                    if (_titleController.text.isEmpty) {
                                      _titleController.text = text;
                                    } else {
                                      _descriptionController.text = text;
                                    }
                                  });
                                },
                                localeId: VoiceInputService.getLocaleId(widget.languageCode),
                              );
                            }
                          },
                          borderRadius: BorderRadius.circular(25),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isDialogListening ? Colors.red.shade50 : themeColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: isDialogListening ? Colors.red : themeColor,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isDialogListening ? Icons.mic_off : Icons.mic,
                                  color: isDialogListening ? Colors.red : themeColor,
                                  size: 20,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  isDialogListening
                                      ? _loc.translate('voice_listening')
                                      : _loc.translate('voice_input'),
                                  style: TextStyle(
                                    color: isDialogListening ? Colors.red : themeColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        _loc.translate('priority_label'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _buildPriorityChip('Thấp', Colors.green, setModalState),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildPriorityChip('Thường', themeColor, setModalState),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildPriorityChip('Cao', Colors.orange, setModalState),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildPriorityChip('Khẩn cấp', Colors.red, setModalState),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      CategoryPicker(
                        selectedCategory: _selectedCategory,
                        onCategorySelected: (category) {
                          setModalState(() {
                            _selectedCategory = category;
                          });
                        },
                        translate: _loc.translate,
                      ),
                      const SizedBox(height: 15),
                      // Due date picker
                      GestureDetector(
                        onTap: () async {
                          // Dismiss keyboard first
                          FocusScope.of(context).unfocus();
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _selectedDueDate ?? DateTime.now().add(const Duration(days: 1)),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );

                          if (date != null) {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(_selectedDueDate ?? DateTime.now()),
                            );

                            if (time != null) {
                              setModalState(() {
                                _selectedDueDate = DateTime(
                                  date.year,
                                  date.month,
                                  date.day,
                                  time.hour,
                                  time.minute,
                                );
                              });
                            }
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today, color: themeColor),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _selectedDueDate == null
                                      ? _loc.translate('due_date_set')
                                      : '${_selectedDueDate!.day}/${_selectedDueDate!.month}/${_selectedDueDate!.year} ${_selectedDueDate!.hour.toString().padLeft(2, '0')}:${_selectedDueDate!.minute.toString().padLeft(2, '0')}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: _selectedDueDate == null ? Colors.grey.shade600 : Colors.black87,
                                  ),
                                ),
                              ),
                              if (_selectedDueDate != null)
                                IconButton(
                                  icon: const Icon(Icons.clear, size: 20),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    setModalState(() {
                                      _selectedDueDate = null;
                                    });
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Text(
                            _loc.translate('checklist_label'),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: () {
                              setModalState(() {
                                if (_checklistItemController.text.trim().isNotEmpty) {
                                  _tempChecklist.add(ChecklistItem(title: _checklistItemController.text.trim()));
                                  _checklistItemController.clear();
                                }
                              });
                              setState(() {});
                            },
                            icon: const Icon(Icons.add, size: 18),
                            label: Text(_loc.translate('checklist_add')),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _checklistItemController,
                        decoration: InputDecoration(
                          hintText: _loc.translate('checklist_hint'),
                          prefixIcon: const Icon(Icons.check_box_outline_blank, size: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onSubmitted: (value) {
                          if (value.trim().isNotEmpty) {
                            setModalState(() {
                              _tempChecklist.add(ChecklistItem(title: value.trim()));
                              _checklistItemController.clear();
                            });
                            setState(() {});
                          }
                        },
                      ),
                      if (_tempChecklist.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Container(
                          constraints: const BoxConstraints(maxHeight: 200),
                          child: SingleChildScrollView(
                            child: NestedChecklist(
                              items: _tempChecklist,
                              onToggle: (item) {
                                setModalState(() {
                                  item.isCompleted = !item.isCompleted;
                                });
                              },
                              onAddChild: (parent, title) {
                                setModalState(() {
                                  parent.children ??= [];
                                  parent.children!.add(ChecklistItem(title: title));
                                });
                              },
                              onDelete: (item) {
                                setModalState(() {
                                  _removeChecklistItem(_tempChecklist, item);
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _addTodo,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Text(
                            _loc.translate('add_button'),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showThemeColorPicker() {
    final colors = [
      // Blues
      Colors.blue,
      Colors.lightBlue,
      Colors.indigo,
      Colors.cyan,
      // Greens
      Colors.green,
      Colors.lightGreen,
      Colors.teal,
      Colors.lime,
      // Warm colors
      Colors.red,
      Colors.pink,
      Colors.orange,
      Colors.amber,
      // Purples & others
      Colors.purple,
      Colors.deepPurple,
      Colors.brown,
      Colors.blueGrey,
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_loc.translate('theme_color')),
        content: SizedBox(
          width: 280,
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: colors.map((color) {
              final isSelected = widget.themeColor == color;
              return GestureDetector(
                onTap: () {
                  widget.onThemeColorChange(color);
                  Navigator.pop(context);
                },
                child: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(color: Colors.white, width: 3)
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.white, size: 20)
                      : null,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _removeChecklistItem(List<ChecklistItem> items, ChecklistItem target) {
    items.removeWhere((item) => item.id == target.id);
    for (var item in items) {
      if (item.children != null) {
        _removeChecklistItem(item.children!, target);
      }
    }
  }

  Widget _buildPriorityChip(String label, Color color, StateSetter setModalState) {
    final isSelected = _selectedPriority == label;
    return GestureDetector(
      onTap: () {
        setModalState(() {
          _selectedPriority = label;
        });
        setState(() {
          _selectedPriority = label;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color,
            width: isSelected ? 0 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Text(
            _getLocalizedPriority(label),
            style: TextStyle(
              color: isSelected ? Colors.white : color,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'Thấp':
        return Colors.green;
      case 'Thường':
        return Colors.blue;
      case 'Cao':
        return Colors.orange;
      case 'Khẩn cấp':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getDueDateColor(DateTime dueDate) {
    final now = DateTime.now();
    final diff = dueDate.difference(now);

    if (diff.isNegative) return Colors.red; // Overdue
    if (diff.inHours < 24) return Colors.orange; // <24h
    return Colors.green; // >24h
  }

  String _formatDueDate(DateTime dueDate) {
    final now = DateTime.now();
    final diff = dueDate.difference(now);

    if (diff.isNegative) {
      return _loc.translate('overdue');
    } else if (diff.inHours < 1) {
      return '${_loc.translate('due_in')} ${diff.inMinutes}${_loc.translate('minutes_short')}';
    } else if (diff.inHours < 24) {
      return '${_loc.translate('due_in')} ${diff.inHours}${_loc.translate('hours_short')}';
    } else {
      return '${_loc.translate('due_in')} ${diff.inDays}${_loc.translate('days_short')}';
    }
  }

  List<Todo> _getFilteredTodos() {
    List<Todo> filtered = _todos;

    // Apply search first
    if (_searchQuery.isNotEmpty) {
      filtered = SearchService.search(filtered, _searchQuery);
    }

    // Check if filter is a category
    final categoryKeys = Category.predefined.map((c) => c.key).toList();

    if (categoryKeys.contains(_filterStatus)) {
      filtered = filtered.where((todo) => todo.category == _filterStatus).toList();
    } else {
      switch (_filterStatus) {
        case 'Hoàn thành':
          filtered = filtered.where((todo) => todo.isCompleted).toList();
          break;
        case 'Chưa hoàn thành':
          filtered = filtered.where((todo) => !todo.isCompleted).toList();
          break;
        case 'Khẩn cấp':
          filtered = filtered.where((todo) => todo.priority == 'Khẩn cấp').toList();
          break;
        case 'Cao':
          filtered = filtered.where((todo) => todo.priority == 'Cao').toList();
          break;
        default:
          break;
      }
    }

    // Sắp xếp
    switch (_sortBy) {
      case 'Mới nhất':
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'Cũ nhất':
        filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case 'Ưu tiên':
        final priorityOrder = {'Khẩn cấp': 0, 'Cao': 1, 'Thường': 2, 'Thấp': 3};
        filtered.sort((a, b) => (priorityOrder[a.priority] ?? 4).compareTo(priorityOrder[b.priority] ?? 4));
        break;
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = widget.themeColor;

    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(themeColor),
              ),
              const SizedBox(height: 20),
              Text(
                _loc.translate('loading_data'),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final filteredTodos = _getFilteredTodos();
    final completedCount = _todos.where((todo) => todo.isCompleted).length;
    final totalCount = _todos.length;
    final urgentCount = _todos.where((todo) => todo.priority == 'Khẩn cấp' && !todo.isCompleted).length;
    final highCount = _todos.where((todo) => todo.priority == 'Cao' && !todo.isCompleted).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _loc.translate('app_title'),
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [themeColor, themeColor.withValues(alpha: 0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        leading: Center(
          child: GestureDetector(
            onTap: () {
              String nextLanguage;
              if (widget.languageCode == 'vi') {
                nextLanguage = 'en';
              } else if (widget.languageCode == 'en') {
                nextLanguage = 'ja';
              } else {
                nextLanguage = 'vi';
              }
              widget.onLanguageChange(nextLanguage);
            },
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  widget.languageCode == 'vi' ? '🇻🇳' : widget.languageCode == 'en' ? '🇺🇸' : '🇯🇵',
                  style: const TextStyle(fontSize: 26),
                ),
              ),
            ),
          ),
        ),
        actions: [
          // Theme color picker button
          IconButton(
            icon: const Icon(Icons.palette, color: Colors.white),
            onPressed: _showThemeColorPicker,
            tooltip: _loc.translate('theme_color'),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort, color: Colors.white),
            onSelected: (value) {
              setState(() {
                _sortBy = value;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'Mới nhất',
                child: Row(
                  children: [
                    Icon(Icons.access_time, size: 20, color: _sortBy == 'Mới nhất' ? themeColor : Colors.grey),
                    const SizedBox(width: 10),
                    Text(_getLocalizedSort('Mới nhất'), style: TextStyle(fontWeight: _sortBy == 'Mới nhất' ? FontWeight.bold : FontWeight.normal)),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'Cũ nhất',
                child: Row(
                  children: [
                    Icon(Icons.history, size: 20, color: _sortBy == 'Cũ nhất' ? themeColor : Colors.grey),
                    const SizedBox(width: 10),
                    Text(_getLocalizedSort('Cũ nhất'), style: TextStyle(fontWeight: _sortBy == 'Cũ nhất' ? FontWeight.bold : FontWeight.normal)),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'Ưu tiên',
                child: Row(
                  children: [
                    Icon(Icons.priority_high, size: 20, color: _sortBy == 'Ưu tiên' ? themeColor : Colors.grey),
                    const SizedBox(width: 10),
                    Text(_getLocalizedSort('Ưu tiên'), style: TextStyle(fontWeight: _sortBy == 'Ưu tiên' ? FontWeight.bold : FontWeight.normal)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [themeColor, themeColor.withValues(alpha: 0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                // Thanh thêm nhanh
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _quickAddController,
                          decoration: InputDecoration(
                            hintText: _isListening
                                ? _loc.translate('voice_listening')
                                : _loc.translate('quick_add_hint'),
                            hintStyle: TextStyle(
                              color: _isListening ? Colors.red.shade400 : Colors.grey.shade400,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                          onSubmitted: (_) => _quickAddTodo(),
                          textInputAction: TextInputAction.done,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                      // Voice input button
                      InkWell(
                        onTap: () {
                          if (_isListening) {
                            _stopVoiceInput();
                          } else {
                            _startVoiceInput(_quickAddController);
                          }
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            _isListening ? Icons.mic_off : Icons.mic,
                            color: _isListening ? Colors.red : Colors.grey.shade600,
                            size: 24,
                          ),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 24,
                        color: Colors.grey.shade300,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                      ),
                      InkWell(
                        onTap: _quickAddTodo,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Icon(Icons.add_circle, color: themeColor, size: 28),
                        ),
                      ),
                      InkWell(
                        onTap: _showAddTodoDialog,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Icon(Icons.more_horiz, color: Colors.grey.shade600, size: 24),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Search bar - only show if there are 3+ todos
                if (_todos.length >= 3) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: Colors.grey.shade600, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: _loc.translate('search_hint'),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value;
                              });
                            },
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        if (_searchQuery.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.clear, size: 20),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                // Thống kê và bộ lọc gộp
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      // Thống kê
                      Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        '$completedCount/$totalCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (urgentCount > 0) ...[
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.red.shade400,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.warning_amber, color: Colors.white, size: 14),
                              const SizedBox(width: 3),
                              Text(
                                '$urgentCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const Spacer(),
                      // Bộ lọc - chỉ icon
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildFilterIconButton('Tất cả', Icons.apps),
                          const SizedBox(width: 6),
                          _buildFilterIconButton('Chưa hoàn thành', Icons.radio_button_unchecked),
                          const SizedBox(width: 6),
                          _buildFilterIconButton('Hoàn thành', Icons.check_circle),
                          if (urgentCount > 0) ...[
                            const SizedBox(width: 6),
                            _buildFilterIconButton('Khẩn cấp', Icons.priority_high, color: Colors.red.shade300),
                          ],
                          if (highCount > 0) ...[
                            const SizedBox(width: 6),
                            _buildFilterIconButton('Cao', Icons.arrow_upward, color: Colors.orange.shade300),
                          ],
                          ...Category.predefined.map((category) {
                            final count = _todos.where((t) => t.category == category.key && !t.isCompleted).length;
                            if (count > 0) {
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(width: 6),
                                  _buildFilterIconButton(category.key, category.icon, color: category.color),
                                ],
                              );
                            }
                            return const SizedBox.shrink();
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredTodos.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _filterStatus == 'Tất cả' ? Icons.inbox_outlined : Icons.filter_list_off,
                          size: 100,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _filterStatus == 'Tất cả'
                              ? _loc.translate('empty_all')
                              : '${_loc.translate('empty_filter')}"${_getLocalizedFilter(_filterStatus)}"',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: filteredTodos.length,
                    itemBuilder: (context, index) {
                      final todo = filteredTodos[index];
                      final actualIndex = _todos.indexOf(todo);

                      return Dismissible(
                        key: Key(todo.createdAt.toString()),
                        background: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.delete_sweep, color: Colors.white, size: 35),
                              const SizedBox(height: 5),
                              Text(_loc.translate('delete'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) => _deleteTodo(actualIndex),
                        child: GestureDetector(
                          onTap: () => _showTodoDetail(todo, actualIndex),
                          child: Card(
                            elevation: todo.isCompleted ? 1 : 3,
                            shadowColor: todo.priority == 'Khẩn cấp' ? Colors.red.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(
                                color: todo.priority == 'Khẩn cấp' && !todo.isCompleted
                                    ? Colors.red.withValues(alpha: 0.4)
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: todo.isCompleted
                                    ? null
                                    : LinearGradient(
                                        colors: [
                                          Colors.white,
                                          _getPriorityColor(todo.priority).withValues(alpha: 0.02),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                              ),
                              child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            leading: GestureDetector(
                              onTap: () => _toggleTodo(actualIndex),
                              child: Container(
                                width: 26,
                                height: 26,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: todo.isCompleted ? Colors.green : _getPriorityColor(todo.priority),
                                    width: 2.5,
                                  ),
                                  color: todo.isCompleted ? Colors.green : Colors.transparent,
                                ),
                                child: todo.isCompleted
                                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                                    : null,
                              ),
                            ),
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    todo.title,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
                                      color: todo.isCompleted ? Colors.grey : Colors.black87,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _getPriorityColor(todo.priority).withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    _getLocalizedPriority(todo.priority),
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: _getPriorityColor(todo.priority),
                                    ),
                                  ),
                                ),
                                if (todo.category != null) ...[
                                  const SizedBox(width: 6),
                                  Icon(
                                    Category.fromKey(todo.category)?.icon ?? Icons.label,
                                    size: 18,
                                    color: Category.fromKey(todo.category)?.color ?? Colors.grey,
                                  ),
                                ],
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (todo.dueDate != null) ...[
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        size: 14,
                                        color: _getDueDateColor(todo.dueDate!),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        _formatDueDate(todo.dueDate!),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: _getDueDateColor(todo.dueDate!),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                if (todo.description.isNotEmpty) ...[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                      todo.description,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: todo.isCompleted ? Colors.grey : Colors.black54,
                                        decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                                if (todo.checklist.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  // Thanh tiến độ checklist
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 6,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius: BorderRadius.circular(3),
                                          ),
                                          child: FractionallySizedBox(
                                            alignment: Alignment.centerLeft,
                                            widthFactor: todo.checklist.where((item) => item.isCompleted).length / todo.checklist.length,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [Colors.green.shade400, Colors.green.shade600],
                                                ),
                                                borderRadius: BorderRadius.circular(3),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '${((todo.checklist.where((item) => item.isCompleted).length / todo.checklist.length) * 100).toInt()}%',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  ...todo.checklist.take(3).map((item) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 3),
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                item.isCompleted = !item.isCompleted;
                                              });
                                            },
                                            child: Icon(
                                              item.isCompleted ? Icons.check_box : Icons.check_box_outline_blank,
                                              size: 16,
                                              color: item.isCompleted ? Colors.green : Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              item.title,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: item.isCompleted ? Colors.grey : Colors.black54,
                                                decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                  if (todo.checklist.length > 3)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2),
                                      child: Text(
                                        '+${todo.checklist.length - 3}${_loc.translate('more_items')}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey.shade600,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                ],
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: Icon(Icons.share, color: themeColor, size: 20),
                                  onPressed: () => _shareTodo(todo),
                                  tooltip: _loc.translate('share'),
                                ),
                                const SizedBox(width: 4),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: const Icon(Icons.close, color: Colors.grey, size: 20),
                                  onPressed: () => _deleteTodo(actualIndex),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: _quickAddController.text.isEmpty
          ? FloatingActionButton(
              onPressed: _showAddTodoDialog,
              backgroundColor: themeColor,
              elevation: 8,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [themeColor, themeColor.withValues(alpha: 0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.add, color: Colors.white, size: 32),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildFilterIconButton(String label, IconData icon, {Color? color}) {
    final isSelected = _filterStatus == label;
    final themeColor = widget.themeColor;

    return GestureDetector(
      onTap: () {
        setState(() {
          _filterStatus = label;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Icon(
          icon,
          size: 18,
          color: isSelected ? (color ?? themeColor) : Colors.white,
        ),
      ),
    );
  }
}
