import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'models/todo.dart';
import 'models/checklist_item.dart';
import 'models/category.dart';
import 'models/tag.dart';
import 'services/storage_service.dart';
import 'services/search_service.dart';
import 'services/notification_service.dart';
import 'services/biometric_service.dart';
import 'services/voice_input_service.dart';
import 'services/backup_service.dart';
import 'widgets/category_picker.dart';
import 'widgets/nested_checklist.dart';
import 'widgets/pomodoro_timer.dart';
import 'widgets/calendar_view.dart';

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
      'add_image': 'Thêm ảnh minh họa',
      'dark_mode': 'Chế độ tối',
      'light_mode': 'Chế độ sáng',
      'settings': 'Cài đặt',
      'tags': 'Nhãn',
      'add_tag': 'Thêm nhãn',
      'tag_hint': 'Nhập tên nhãn...',
      'pomodoro': 'Pomodoro',
      'pomodoro_work': 'Làm việc',
      'pomodoro_break': 'Nghỉ ngơi',
      'pomodoro_start': 'Bắt đầu',
      'pomodoro_pause': 'Tạm dừng',
      'pomodoro_reset': 'Đặt lại',
      'pomodoro_complete': 'Hoàn thành phiên làm việc!',
      'pomodoro_sessions': 'Phiên',
      'calendar': 'Lịch',
      'today': 'Hôm nay',
      'backup': 'Sao lưu',
      'restore': 'Khôi phục',
      'export_data': 'Xuất dữ liệu',
      'import_data': 'Nhập dữ liệu',
      'backup_success': 'Sao lưu thành công!',
      'restore_success': 'Khôi phục thành công!',
      'no_tasks_today': 'Không có công việc hôm nay',
      'exit_app': 'Thoát ứng dụng',
      'exit_confirm': 'Bạn có muốn lưu và thoát ứng dụng?',
      'exit_save_exit': 'Lưu & Thoát',
      'cancel': 'Hủy',
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
      'add_image': 'Add image',
      'dark_mode': 'Dark Mode',
      'light_mode': 'Light Mode',
      'settings': 'Settings',
      'tags': 'Tags',
      'add_tag': 'Add tag',
      'tag_hint': 'Enter tag name...',
      'pomodoro': 'Pomodoro',
      'pomodoro_work': 'Work',
      'pomodoro_break': 'Break',
      'pomodoro_start': 'Start',
      'pomodoro_pause': 'Pause',
      'pomodoro_reset': 'Reset',
      'pomodoro_complete': 'Work session complete!',
      'pomodoro_sessions': 'Sessions',
      'calendar': 'Calendar',
      'today': 'Today',
      'backup': 'Backup',
      'restore': 'Restore',
      'export_data': 'Export Data',
      'import_data': 'Import Data',
      'backup_success': 'Backup successful!',
      'restore_success': 'Restore successful!',
      'no_tasks_today': 'No tasks for today',
      'exit_app': 'Exit App',
      'exit_confirm': 'Do you want to save and exit?',
      'exit_save_exit': 'Save & Exit',
      'cancel': 'Cancel',
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
      'add_image': '画像を追加',
      'dark_mode': 'ダークモード',
      'light_mode': 'ライトモード',
      'settings': '設定',
      'tags': 'タグ',
      'add_tag': 'タグを追加',
      'tag_hint': 'タグ名を入力...',
      'pomodoro': 'ポモドーロ',
      'pomodoro_work': '作業',
      'pomodoro_break': '休憩',
      'pomodoro_start': '開始',
      'pomodoro_pause': '一時停止',
      'pomodoro_reset': 'リセット',
      'pomodoro_complete': '作業セッション完了！',
      'pomodoro_sessions': 'セッション',
      'calendar': 'カレンダー',
      'today': '今日',
      'backup': 'バックアップ',
      'restore': '復元',
      'export_data': 'データエクスポート',
      'import_data': 'データインポート',
      'backup_success': 'バックアップ成功！',
      'restore_success': '復元成功！',
      'no_tasks_today': '今日のタスクはありません',
      'exit_app': 'アプリを終了',
      'exit_confirm': '保存して終了しますか？',
      'exit_save_exit': '保存して終了',
      'cancel': 'キャンセル',
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
  bool _isDarkMode = false;

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

  void toggleDarkMode(bool value) {
    setState(() {
      _isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppLocalizations(_languageCode).translate('app_title'),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _themeColor,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey.shade50,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _themeColor,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: TodoHomePage(
        languageCode: _languageCode,
        onLanguageChange: changeLanguage,
        storageService: widget.storageService,
        themeColor: _themeColor,
        onThemeColorChange: changeThemeColor,
        isDarkMode: _isDarkMode,
        onDarkModeChange: toggleDarkMode,
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
  final bool isDarkMode;
  final Function(bool) onDarkModeChange;

  const TodoHomePage({
    super.key,
    required this.languageCode,
    required this.onLanguageChange,
    required this.storageService,
    required this.themeColor,
    required this.onThemeColorChange,
    required this.isDarkMode,
    required this.onDarkModeChange,
  });

  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> with WidgetsBindingObserver {
  List<Todo> _todos = [];
  List<Tag> _tags = [];
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
  late StorageService _storage;
  String _searchQuery = '';
  bool _isListening = false;
  String? _selectedImagePath;
  int _currentViewIndex = 0; // 0: Tasks, 1: Calendar, 2: Pomodoro

  AppLocalizations get _loc => AppLocalizations(widget.languageCode);

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
      _storage.saveTodos(_todos);
      _storage.saveTags(_tags);
    }
  }

  Future<void> _loadTodos() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final todos = _storage.loadTodos();
      final tags = _storage.loadTags();
      setState(() {
        _todos = todos;
        _tags = tags;
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

  void _saveTodos() {
    _storage.saveTodos(_todos);
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

    _saveTodos();
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
      imagePath: _selectedImagePath,
    );

    setState(() {
      _todos.insert(0, newTodo);
    });

    _saveTodos();

    // Schedule notification if due date is set
    if (newTodo.dueDate != null) {
      NotificationService.scheduleTodoReminder(newTodo);
    }

    _titleController.clear();
    _descriptionController.clear();
    _selectedPriority = 'Thường';
    _selectedCategory = null;
    _selectedDueDate = null;
    _selectedImagePath = null;
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
    _saveTodos();

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
    _saveTodos();

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
            _saveTodos();
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

  String _getNextPriority(String currentPriority) {
    final priorities = ['Thấp', 'Thường', 'Cao', 'Khẩn cấp'];
    final currentIndex = priorities.indexOf(currentPriority);
    final nextIndex = (currentIndex + 1) % priorities.length;
    return priorities[nextIndex];
  }

  IconData _getPriorityIcon(String priority) {
    switch (priority) {
      case 'Thấp':
        return Icons.arrow_downward;
      case 'Thường':
        return Icons.remove;
      case 'Cao':
        return Icons.arrow_upward;
      case 'Khẩn cấp':
        return Icons.priority_high;
      default:
        return Icons.remove;
    }
  }

  void _showTodoDetail(Todo todo, int index) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
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
                    colors: [_getPriorityColor(todo.priority), _getPriorityColor(todo.priority).withValues(alpha: 0.7)],
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
                            ? Icon(Icons.check, color: _getPriorityColor(todo.priority), size: 20)
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
                          GestureDetector(
                            onTap: () {
                              setDialogState(() {
                                todo.priority = _getNextPriority(todo.priority);
                              });
                              setState(() {});
                              _saveTodos();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _getPriorityIcon(todo.priority),
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _getLocalizedPriority(todo.priority),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
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
                            Icon(Icons.description, color: _getPriorityColor(todo.priority), size: 20),
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
                      if (todo.imagePath != null) ...[
                        Row(
                          children: [
                            Icon(Icons.image, color: _getPriorityColor(todo.priority), size: 20),
                            const SizedBox(width: 8),
                            Text(
                              _loc.translate('add_image'),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(todo.imagePath!),
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                      if (todo.checklist.isNotEmpty) ...[
                        Row(
                          children: [
                            Icon(Icons.checklist, color: _getPriorityColor(todo.priority), size: 20),
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
      ),
    );
  }

  Future<String?> _pickAndSaveImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (image == null) return null;

    // Save to app documents directory
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${path.basename(image.path)}';
    final savedImage = await File(image.path).copy('${appDir.path}/$fileName');

    return savedImage.path;
  }

  void _showAddTodoDialog() {
    _titleController.clear();
    _descriptionController.clear();
    _selectedPriority = 'Thường';
    _selectedCategory = null;
    // Set default due date to tomorrow same time
    final now = DateTime.now();
    _selectedDueDate = DateTime(now.year, now.month, now.day + 1, now.hour, now.minute);
    _selectedImagePath = null;
    _tempChecklist.clear();
    bool isDialogListening = false;
    String voiceTargetField = 'title'; // Track which field is receiving voice input

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
                maxHeight: MediaQuery.of(context).size.height * 0.9,
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header với gradient
                  Container(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [themeColor, themeColor.withValues(alpha: 0.8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                    ),
                    child: Column(
                      children: [
                        // Handle bar
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.add_task, color: Colors.white, size: 24),
                            ),
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.close, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Content
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title field
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _titleController,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                              decoration: InputDecoration(
                                hintText: (isDialogListening && voiceTargetField == 'title')
                                    ? _loc.translate('voice_listening')
                                    : _loc.translate('title_hint'),
                                hintStyle: TextStyle(color: Colors.grey.shade400),
                                prefixIcon: Icon(Icons.edit_outlined, color: themeColor),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    (isDialogListening && voiceTargetField == 'title') ? Icons.mic_off : Icons.mic_none,
                                    color: (isDialogListening && voiceTargetField == 'title') ? Colors.red : Colors.grey.shade400,
                                  ),
                                  onPressed: () async {
                                    if (isDialogListening && voiceTargetField == 'title') {
                                      await VoiceInputService.stopListening();
                                      setModalState(() => isDialogListening = false);
                                    } else {
                                      final isAvailable = await VoiceInputService.isAvailable();
                                      if (!isAvailable) {
                                        if (mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text(_loc.translate('voice_not_available')), backgroundColor: Colors.orange),
                                          );
                                        }
                                        return;
                                      }
                                      if (isDialogListening) await VoiceInputService.stopListening();
                                      setModalState(() { isDialogListening = true; voiceTargetField = 'title'; });
                                      await VoiceInputService.startListening(
                                        onResult: (text) => setModalState(() => _titleController.text = text),
                                        localeId: VoiceInputService.getLocaleId(widget.languageCode),
                                      );
                                    }
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Description field
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _descriptionController,
                              maxLines: 3,
                              style: const TextStyle(fontSize: 15),
                              decoration: InputDecoration(
                                hintText: (isDialogListening && voiceTargetField == 'description')
                                    ? _loc.translate('voice_listening')
                                    : _loc.translate('description_hint'),
                                hintStyle: TextStyle(color: Colors.grey.shade400),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(bottom: 40),
                                  child: Icon(Icons.notes_outlined, color: themeColor),
                                ),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(bottom: 40),
                                  child: IconButton(
                                    icon: Icon(
                                      (isDialogListening && voiceTargetField == 'description') ? Icons.mic_off : Icons.mic_none,
                                      color: (isDialogListening && voiceTargetField == 'description') ? Colors.red : Colors.grey.shade400,
                                    ),
                                    onPressed: () async {
                                      if (isDialogListening && voiceTargetField == 'description') {
                                        await VoiceInputService.stopListening();
                                        setModalState(() => isDialogListening = false);
                                      } else {
                                        final isAvailable = await VoiceInputService.isAvailable();
                                        if (!isAvailable) {
                                          if (mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text(_loc.translate('voice_not_available')), backgroundColor: Colors.orange),
                                            );
                                          }
                                          return;
                                        }
                                        if (isDialogListening) await VoiceInputService.stopListening();
                                        setModalState(() { isDialogListening = true; voiceTargetField = 'description'; });
                                        await VoiceInputService.startListening(
                                          onResult: (text) => setModalState(() => _descriptionController.text = text),
                                          localeId: VoiceInputService.getLocaleId(widget.languageCode),
                                        );
                                      }
                                    },
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Priority Section
                          _buildSectionCard(
                            icon: Icons.flag_outlined,
                            themeColor: themeColor,
                            child: Row(
                              children: [
                                Expanded(child: _buildPriorityChip('Thấp', Colors.green, setModalState)),
                                const SizedBox(width: 8),
                                Expanded(child: _buildPriorityChip('Thường', themeColor, setModalState)),
                                const SizedBox(width: 8),
                                Expanded(child: _buildPriorityChip('Cao', Colors.orange, setModalState)),
                                const SizedBox(width: 8),
                                Expanded(child: _buildPriorityChip('Khẩn cấp', Colors.red, setModalState)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Category Section
                          _buildSectionCard(
                            icon: Icons.category_outlined,
                            themeColor: themeColor,
                            child: CategoryPicker(
                              selectedCategory: _selectedCategory,
                              onCategorySelected: (category) => setModalState(() => _selectedCategory = category),
                              translate: _loc.translate,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Due Date & Image Row
                          Row(
                            children: [
                              // Due Date
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
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
                                          _selectedDueDate = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                                        });
                                      }
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2)),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.schedule_outlined, color: themeColor, size: 24),
                                            if (_selectedDueDate != null) ...[
                                              const SizedBox(width: 8),
                                              GestureDetector(
                                                onTap: () => setModalState(() => _selectedDueDate = null),
                                                child: Icon(Icons.close, size: 16, color: Colors.grey.shade400),
                                              ),
                                            ],
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          _selectedDueDate == null
                                              ? '--/--'
                                              : '${_selectedDueDate!.day}/${_selectedDueDate!.month}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: _selectedDueDate == null ? Colors.grey.shade400 : Colors.grey.shade800,
                                          ),
                                        ),
                                        if (_selectedDueDate != null)
                                          Text(
                                            '${_selectedDueDate!.hour.toString().padLeft(2, '0')}:${_selectedDueDate!.minute.toString().padLeft(2, '0')}',
                                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Image Picker
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    final imagePath = await _pickAndSaveImage();
                                    if (imagePath != null) setModalState(() => _selectedImagePath = imagePath);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2)),
                                      ],
                                    ),
                                    child: _selectedImagePath != null
                                        ? Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(12),
                                                child: Image.file(File(_selectedImagePath!), height: 50, width: double.infinity, fit: BoxFit.cover),
                                              ),
                                              Positioned(
                                                top: -4,
                                                right: -4,
                                                child: GestureDetector(
                                                  onTap: () => setModalState(() => _selectedImagePath = null),
                                                  child: Container(
                                                    padding: const EdgeInsets.all(4),
                                                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                                                    child: const Icon(Icons.close, color: Colors.white, size: 14),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Center(
                                            child: Icon(Icons.add_photo_alternate_outlined, color: themeColor, size: 40),
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Checklist Section
                          _buildSectionCard(
                            icon: Icons.checklist_outlined,
                            themeColor: themeColor,
                            trailing: IconButton(
                              onPressed: () {
                                if (_checklistItemController.text.trim().isNotEmpty) {
                                  setModalState(() {
                                    _tempChecklist.add(ChecklistItem(title: _checklistItemController.text.trim()));
                                    _checklistItemController.clear();
                                  });
                                }
                              },
                              icon: Icon(Icons.add_circle, color: themeColor, size: 26),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            child: Column(
                              children: [
                                TextField(
                                  controller: _checklistItemController,
                                  style: const TextStyle(fontSize: 14),
                                  decoration: InputDecoration(
                                    hintText: _loc.translate('checklist_hint'),
                                    hintStyle: TextStyle(color: Colors.grey.shade400),
                                    prefixIcon: Icon(Icons.add, size: 20, color: Colors.grey.shade400),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: themeColor)),
                                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                                    filled: true,
                                    fillColor: Colors.grey.shade50,
                                  ),
                                  onSubmitted: (value) {
                                    if (value.trim().isNotEmpty) {
                                      setModalState(() {
                                        _tempChecklist.add(ChecklistItem(title: value.trim()));
                                        _checklistItemController.clear();
                                      });
                                    }
                                  },
                                ),
                                if (_tempChecklist.isNotEmpty) ...[
                                  const SizedBox(height: 12),
                                  Container(
                                    constraints: const BoxConstraints(maxHeight: 150),
                                    child: SingleChildScrollView(
                                      child: NestedChecklist(
                                        items: _tempChecklist,
                                        onToggle: (item) => setModalState(() => item.isCompleted = !item.isCompleted),
                                        onAddChild: (parent, title) => setModalState(() {
                                          parent.children ??= [];
                                          parent.children!.add(ChecklistItem(title: title));
                                        }),
                                        onDelete: (item) => setModalState(() => _removeChecklistItem(_tempChecklist, item)),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Add Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _addTodo,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: themeColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                elevation: 2,
                                shadowColor: themeColor.withValues(alpha: 0.3),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.add_task, size: 22),
                                  const SizedBox(width: 10),
                                  Text(
                                    _loc.translate('add_button'),
                                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, letterSpacing: 0.3),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required Color themeColor,
    required Widget child,
    Widget? trailing,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: themeColor, size: 20),
              const Spacer(),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
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
        contentPadding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: SizedBox(
          width: 240,
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: colors.length,
            itemBuilder: (context, index) {
              final color = colors[index];
              final isSelected = widget.themeColor == color;
              return GestureDetector(
                onTap: () {
                  widget.onThemeColorChange(color);
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(color: Colors.white, width: 3)
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.4),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.white, size: 20)
                      : null,
                ),
              );
            },
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

  void _showBackupDialog() {
    final themeColor = widget.themeColor;
    final isDark = widget.isDarkMode;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.backup, color: themeColor),
            const SizedBox(width: 10),
            Text(
              _loc.translate('backup'),
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.upload, color: themeColor),
              title: Text(
                _loc.translate('export_data'),
                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              ),
              onTap: () async {
                Navigator.pop(context);
                await BackupService.shareBackup(todos: _todos, tags: _tags);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_loc.translate('backup_success')),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.download, color: themeColor),
              title: Text(
                _loc.translate('import_data'),
                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              ),
              onTap: () async {
                Navigator.pop(context);
                // File picker would go here - for now show info
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(_loc.translate('import_data')),
                    backgroundColor: themeColor,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showTagsDialog() {
    final themeColor = widget.themeColor;
    final isDark = widget.isDarkMode;
    final tagController = TextEditingController();
    Color selectedColor = Tag.availableColors[0];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(Icons.label, color: themeColor),
              const SizedBox(width: 10),
              Text(
                _loc.translate('tags'),
                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              ),
            ],
          ),
          content: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Add new tag
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: tagController,
                        style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                        decoration: InputDecoration(
                          hintText: _loc.translate('tag_hint'),
                          hintStyle: TextStyle(color: isDark ? Colors.white54 : Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Pick a color'),
                            content: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: Tag.availableColors.map((color) {
                                return GestureDetector(
                                  onTap: () {
                                    setDialogState(() => selectedColor = color);
                                    Navigator.pop(ctx);
                                  },
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                      border: selectedColor == color
                                          ? Border.all(color: Colors.white, width: 3)
                                          : null,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: selectedColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        if (tagController.text.trim().isNotEmpty) {
                          setState(() {
                            _tags.add(Tag(
                              name: tagController.text.trim(),
                              color: selectedColor,
                            ));
                          });
                          _storage.saveTags(_tags);
                          setDialogState(() {});
                          tagController.clear();
                        }
                      },
                      icon: Icon(Icons.add_circle, color: themeColor, size: 32),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Tags list
                if (_tags.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'No tags yet',
                      style: TextStyle(color: isDark ? Colors.white54 : Colors.grey),
                    ),
                  )
                else
                  Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _tags.length,
                      itemBuilder: (context, index) {
                        final tag = _tags[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: tag.color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: tag.color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  tag.name,
                                  style: TextStyle(
                                    color: isDark ? Colors.white : Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _tags.removeAt(index);
                                  });
                                  _storage.saveTags(_tags);
                                  setDialogState(() {});
                                },
                                icon: Icon(Icons.close, color: Colors.red.shade400, size: 20),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK', style: TextStyle(color: themeColor)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityChip(String label, Color color, StateSetter setModalState) {
    final isSelected = _selectedPriority == label;
    IconData icon;
    switch (label) {
      case 'Thấp':
        icon = Icons.arrow_downward;
        break;
      case 'Thường':
        icon = Icons.remove;
        break;
      case 'Cao':
        icon = Icons.arrow_upward;
        break;
      case 'Khẩn cấp':
        icon = Icons.priority_high;
        break;
      default:
        icon = Icons.remove;
    }

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
        padding: const EdgeInsets.all(12),
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
          child: Icon(
            icon,
            color: isSelected ? Colors.white : color,
            size: 22,
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
          // Dark mode toggle
          IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: Colors.white,
            ),
            onPressed: () => widget.onDarkModeChange(!widget.isDarkMode),
            tooltip: widget.isDarkMode ? _loc.translate('light_mode') : _loc.translate('dark_mode'),
          ),
          // Theme color picker button
          IconButton(
            icon: const Icon(Icons.palette, color: Colors.white),
            onPressed: _showThemeColorPicker,
            tooltip: _loc.translate('theme_color'),
          ),
          // Settings menu
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              switch (value) {
                case 'backup':
                  _showBackupDialog();
                  break;
                case 'tags':
                  _showTagsDialog();
                  break;
                case 'exit':
                  _showExitDialog();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'tags',
                child: Row(
                  children: [
                    Icon(Icons.label_outline, color: themeColor),
                    const SizedBox(width: 10),
                    Text(_loc.translate('tags')),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'backup',
                child: Row(
                  children: [
                    Icon(Icons.backup_outlined, color: themeColor),
                    const SizedBox(width: 10),
                    Text(_loc.translate('backup')),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'exit',
                child: Row(
                  children: [
                    Icon(Icons.exit_to_app, color: Colors.red),
                    const SizedBox(width: 10),
                    Text(_loc.translate('exit_app'), style: const TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
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
                      IconButton(
                        onPressed: () {
                          if (_isListening) {
                            _stopVoiceInput();
                          } else {
                            _startVoiceInput(_quickAddController);
                          }
                        },
                        icon: Icon(
                          _isListening ? Icons.mic_off : Icons.mic,
                          color: _isListening ? Colors.red : Colors.grey.shade600,
                          size: 24,
                        ),
                        padding: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(),
                        splashRadius: 24,
                      ),
                      Container(
                        width: 1,
                        height: 24,
                        color: Colors.grey.shade300,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                      ),
                      IconButton(
                        onPressed: _quickAddTodo,
                        icon: Icon(Icons.add_circle, color: themeColor, size: 28),
                        padding: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(),
                        splashRadius: 24,
                      ),
                      IconButton(
                        onPressed: _showAddTodoDialog,
                        icon: Icon(Icons.more_horiz, color: Colors.grey.shade600, size: 24),
                        padding: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(),
                        splashRadius: 24,
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
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: filteredTodos.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(30),
                              decoration: BoxDecoration(
                                color: themeColor.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _filterStatus == 'Tất cả' || _filterStatus == 'Chưa hoàn thành'
                                    ? Icons.task_alt
                                    : Icons.filter_list_off,
                                size: 70,
                                color: themeColor.withValues(alpha: 0.5),
                              ),
                            ),
                            const SizedBox(height: 28),
                            Text(
                              _filterStatus == 'Tất cả' || _filterStatus == 'Chưa hoàn thành'
                                  ? _loc.translate('empty_all').split('\n')[0]
                                  : _loc.translate('empty_filter'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _filterStatus == 'Tất cả' || _filterStatus == 'Chưa hoàn thành'
                                  ? (_loc.translate('empty_all').contains('\n')
                                      ? _loc.translate('empty_all').split('\n')[1]
                                      : '')
                                  : '"${_getLocalizedFilter(_filterStatus)}"',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey.shade500,
                                height: 1.5,
                              ),
                            ),
                            if (_filterStatus == 'Tất cả' || _filterStatus == 'Chưa hoàn thành') ...[
                              const SizedBox(height: 30),
                              ElevatedButton.icon(
                                onPressed: _showAddTodoDialog,
                                icon: const Icon(Icons.add, size: 20),
                                label: Text(_loc.translate('add_button')),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: themeColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                  elevation: 2,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: filteredTodos.length,
                    itemBuilder: (context, index) {
                      final todo = filteredTodos[index];
                      final actualIndex = _todos.indexOf(todo);
                      final priorityColor = _getPriorityColor(todo.priority);

                      return Dismissible(
                        key: Key(todo.createdAt.toString()),
                        background: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.red.shade400, Colors.red.shade600],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 24),
                          child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) => _deleteTodo(actualIndex),
                        child: GestureDetector(
                          onTap: () => _showTodoDetail(todo, actualIndex),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: todo.isCompleted
                                      ? Colors.grey.withValues(alpha: 0.1)
                                      : priorityColor.withValues(alpha: 0.15),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      color: todo.isCompleted ? Colors.green : priorityColor,
                                      width: 4,
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Header row: checkbox, title, badges
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Checkbox
                                          GestureDetector(
                                            onTap: () => _toggleTodo(actualIndex),
                                            child: AnimatedContainer(
                                              duration: const Duration(milliseconds: 200),
                                              width: 28,
                                              height: 28,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: todo.isCompleted ? Colors.green : Colors.transparent,
                                                border: Border.all(
                                                  color: todo.isCompleted ? Colors.green : priorityColor,
                                                  width: 2.5,
                                                ),
                                              ),
                                              child: todo.isCompleted
                                                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                                                  : null,
                                            ),
                                          ),
                                          const SizedBox(width: 14),
                                          // Title and badges
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  todo.title,
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: -0.3,
                                                    decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
                                                    decorationColor: Colors.grey.shade400,
                                                    color: todo.isCompleted ? Colors.grey.shade500 : Colors.grey.shade800,
                                                  ),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 8),
                                                // Badges row
                                                Wrap(
                                                  spacing: 8,
                                                  runSpacing: 6,
                                                  children: [
                                                    // Priority badge
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                      decoration: BoxDecoration(
                                                        color: priorityColor.withValues(alpha: 0.12),
                                                        borderRadius: BorderRadius.circular(20),
                                                      ),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Icon(
                                                            _getPriorityIcon(todo.priority),
                                                            size: 12,
                                                            color: priorityColor,
                                                          ),
                                                          const SizedBox(width: 4),
                                                          Text(
                                                            _getLocalizedPriority(todo.priority),
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              fontWeight: FontWeight.w600,
                                                              color: priorityColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    // Category badge
                                                    if (todo.category != null)
                                                      Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                        decoration: BoxDecoration(
                                                          color: (Category.fromKey(todo.category)?.color ?? Colors.grey).withValues(alpha: 0.12),
                                                          borderRadius: BorderRadius.circular(20),
                                                        ),
                                                        child: Icon(
                                                          Category.fromKey(todo.category)?.icon ?? Icons.label,
                                                          size: 14,
                                                          color: Category.fromKey(todo.category)?.color ?? Colors.grey,
                                                        ),
                                                      ),
                                                    // Due date badge
                                                    if (todo.dueDate != null)
                                                      Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                        decoration: BoxDecoration(
                                                          color: _getDueDateColor(todo.dueDate!).withValues(alpha: 0.12),
                                                          borderRadius: BorderRadius.circular(20),
                                                        ),
                                                        child: Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Icon(
                                                              Icons.schedule,
                                                              size: 12,
                                                              color: _getDueDateColor(todo.dueDate!),
                                                            ),
                                                            const SizedBox(width: 4),
                                                            Text(
                                                              _formatDueDate(todo.dueDate!),
                                                              style: TextStyle(
                                                                fontSize: 11,
                                                                fontWeight: FontWeight.w600,
                                                                color: _getDueDateColor(todo.dueDate!),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Action buttons
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  borderRadius: BorderRadius.circular(20),
                                                  onTap: () => _shareTodo(todo),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8),
                                                    child: Icon(Icons.share_outlined, color: themeColor.withValues(alpha: 0.7), size: 20),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      // Description
                                      if (todo.description.isNotEmpty) ...[
                                        const SizedBox(height: 12),
                                        Text(
                                          todo.description,
                                          style: TextStyle(
                                            fontSize: 14,
                                            height: 1.4,
                                            color: todo.isCompleted ? Colors.grey.shade400 : Colors.grey.shade600,
                                            decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                      // Checklist progress
                                      if (todo.checklist.isNotEmpty) ...[
                                        const SizedBox(height: 14),
                                        // Progress bar
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(4),
                                                child: LinearProgressIndicator(
                                                  value: todo.checklist.where((item) => item.isCompleted).length / todo.checklist.length,
                                                  backgroundColor: Colors.grey.shade200,
                                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade500),
                                                  minHeight: 6,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              '${todo.checklist.where((item) => item.isCompleted).length}/${todo.checklist.length}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        // Checklist items preview
                                        ...todo.checklist.take(2).map((item) {
                                          return Padding(
                                            padding: const EdgeInsets.only(bottom: 6),
                                            child: Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      item.isCompleted = !item.isCompleted;
                                                    });
                                                    _saveTodos();
                                                  },
                                                  child: AnimatedContainer(
                                                    duration: const Duration(milliseconds: 150),
                                                    width: 18,
                                                    height: 18,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(4),
                                                      color: item.isCompleted ? Colors.green.shade500 : Colors.transparent,
                                                      border: Border.all(
                                                        color: item.isCompleted ? Colors.green.shade500 : Colors.grey.shade400,
                                                        width: 1.5,
                                                      ),
                                                    ),
                                                    child: item.isCompleted
                                                        ? const Icon(Icons.check, color: Colors.white, size: 12)
                                                        : null,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Text(
                                                    item.title,
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: item.isCompleted ? Colors.grey.shade400 : Colors.grey.shade700,
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
                                        if (todo.checklist.length > 2)
                                          Padding(
                                            padding: const EdgeInsets.only(top: 4),
                                            child: Text(
                                              '+${todo.checklist.length - 2}${_loc.translate('more_items')}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: themeColor.withValues(alpha: 0.7),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            ),
          ),
        ],
      ),
      floatingActionButton: _quickAddController.text.isEmpty
          ? Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [themeColor, themeColor.withValues(alpha: 0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: themeColor.withValues(alpha: 0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: FloatingActionButton(
                onPressed: _showAddTodoDialog,
                backgroundColor: Colors.transparent,
                elevation: 0,
                child: const Icon(Icons.add, color: Colors.white, size: 30),
              ),
            )
          : null,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: widget.isDarkMode ? Colors.grey.shade900 : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.task_alt, _loc.translate('app_title').split(' ')[0]),
                _buildNavItem(1, Icons.calendar_month, _loc.translate('calendar')),
                _buildNavItem(2, Icons.timer, _loc.translate('pomodoro')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentViewIndex == index;
    final themeColor = widget.themeColor;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentViewIndex = index;
        });
        if (index == 1) {
          _showCalendarView();
        } else if (index == 2) {
          _showPomodoroTimer();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? themeColor.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? themeColor : (widget.isDarkMode ? Colors.white54 : Colors.grey),
              size: 24,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: themeColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showCalendarView() {
    final themeColor = widget.themeColor;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: widget.isDarkMode ? const Color(0xFF121212) : Colors.grey.shade100,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [themeColor, themeColor.withValues(alpha: 0.8)],
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month, color: Colors.white, size: 28),
                  const SizedBox(width: 12),
                  Text(
                    _loc.translate('calendar'),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() => _currentViewIndex = 0);
                    },
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
            // Calendar
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: CalendarViewWidget(
                  todos: _todos,
                  translate: _loc.translate,
                  themeColor: themeColor,
                  isDarkMode: widget.isDarkMode,
                  onTodoTap: (todo) {
                    Navigator.pop(context);
                    final index = _todos.indexOf(todo);
                    if (index != -1) {
                      _showTodoDetail(todo, index);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    ).then((_) {
      setState(() => _currentViewIndex = 0);
    });
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: widget.isDarkMode ? Colors.grey.shade900 : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.exit_to_app, color: Colors.red),
            const SizedBox(width: 10),
            Text(
              _loc.translate('exit_app'),
              style: TextStyle(color: widget.isDarkMode ? Colors.white : Colors.black87),
            ),
          ],
        ),
        content: Text(
          _loc.translate('exit_confirm'),
          style: TextStyle(color: widget.isDarkMode ? Colors.white70 : Colors.black54),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_loc.translate('cancel')),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              // Save all data
              await _storage.saveTodos(_todos);
              await _storage.saveTags(_tags);
              // Close the app
              exit(0);
            },
            child: Text(_loc.translate('exit_save_exit')),
          ),
        ],
      ),
    );
  }

  void _showPomodoroTimer() {
    final themeColor = widget.themeColor;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: widget.isDarkMode ? const Color(0xFF121212) : Colors.grey.shade100,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [themeColor, themeColor.withValues(alpha: 0.8)],
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.timer, color: Colors.white, size: 28),
                  const SizedBox(width: 12),
                  Text(
                    _loc.translate('pomodoro'),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() => _currentViewIndex = 0);
                    },
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
            // Timer
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: PomodoroTimer(
                    translate: _loc.translate,
                    themeColor: themeColor,
                    isDarkMode: widget.isDarkMode,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ).then((_) {
      setState(() => _currentViewIndex = 0);
    });
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