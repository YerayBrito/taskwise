import 'package:flutter/material.dart';
import '../models/task.dart';
import '../database/database_helper.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  List<String> _categories = [];
  List<String> _tags = [];
  String? _filterCategory;
  String _filterStatus = 'All'; // All, Pending, Completed
  TaskPriority? _filterPriority;
  String? _filterDateRange;
  String _searchQuery = '';
  String _sortBy = 'dueDate';
  Map<String, dynamic> _statistics = {};

  final DatabaseHelper _dbHelper;

  List<Task> get tasks {
    if (_filterStatus == 'Pending') {
      return _tasks.where((task) => !task.isCompleted).toList();
    } else if (_filterStatus == 'Completed') {
      return _tasks.where((task) => task.isCompleted).toList();
    }
    // Default to 'All'
    return _tasks;
  }

  List<Task> get filteredTasks {
    List<Task> filtered = tasks;
    
    // Aplicar filtro de categoría
    if (_filterCategory != null && _filterCategory != 'All') {
      filtered = filtered.where((task) => task.category == _filterCategory).toList();
    }
    
    // Aplicar filtro de prioridad
    if (_filterPriority != null) {
      filtered = filtered.where((task) => task.priority == _filterPriority).toList();
    }
    
    // Aplicar filtro de rango de fecha
    if (_filterDateRange != null) {
      filtered = _applyDateRangeFilter(filtered);
    }
    
    // Aplicar búsqueda
    if (_searchQuery.isNotEmpty) {
      filtered = _applySearchFilter(filtered);
    }
    
    // Aplicar ordenamiento
    filtered = _applySorting(filtered);
    
    return filtered;
  }
  
  List<String> get categories => ['All', ..._categories];
  List<String> get tags => _tags;
  String? get filterCategory => _filterCategory;
  String get filterStatus => _filterStatus;
  TaskPriority? get filterPriority => _filterPriority;
  String? get filterDateRange => _filterDateRange;
  String get searchQuery => _searchQuery;
  String get sortBy => _sortBy;
  Map<String, dynamic> get statistics => _statistics;

  TaskProvider({DatabaseHelper? dbHelper}) : _dbHelper = dbHelper ?? DatabaseHelper() {
    loadTasks();
    loadCategories();
    loadTags();
    loadStatistics();
  }

  void loadTasks() async {
    _tasks = await _dbHelper.getTasks();
    notifyListeners();
  }

  void loadCategories() async {
    _categories = await _dbHelper.getCategories();
    notifyListeners();
  }

  void loadTags() async {
    _tags = await _dbHelper.getAllTags();
    notifyListeners();
  }

  void loadStatistics() async {
    _statistics = await _dbHelper.getTaskStatistics();
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await _dbHelper.insertTask(task);
    await _refreshData();
  }

  Future<void> updateTask(Task task) async {
    await _dbHelper.updateTask(task);
    await _refreshData();
  }

  Future<void> deleteTask(int id) async {
    await _dbHelper.deleteTask(id);
    await _refreshData();
  }

  Future<void> toggleTaskStatus(Task task) async {
    final updatedTask = task.copyWith(
      isCompleted: !task.isCompleted,
      completedAt: !task.isCompleted ? DateTime.now() : null,
    );
    await updateTask(updatedTask);
  }

  Future<void> _refreshData() async {
    await Future.wait([
      loadTasks(),
      loadCategories(),
      loadTags(),
      loadStatistics(),
    ] as Iterable<Future>);
  }

  void setFilterByCategory(String? category) {
    _filterCategory = category;
    notifyListeners();
  }

  void setFilterByStatus(String status) {
    _filterStatus = status;
    notifyListeners();
  }

  void setFilterByPriority(TaskPriority? priority) {
    _filterPriority = priority;
    notifyListeners();
  }

  void setFilterByDateRange(String? dateRange) {
    _filterDateRange = dateRange;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSortBy(String sortBy) {
    _sortBy = sortBy;
    notifyListeners();
  }

  void clearAllFilters() {
    _filterCategory = null;
    _filterStatus = 'All';
    _filterPriority = null;
    _filterDateRange = null;
    _searchQuery = '';
    _sortBy = 'dueDate';
    notifyListeners();
  }

  List<Task> _applyDateRangeFilter(List<Task> tasks) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final endOfWeek = today.add(Duration(days: 7 - today.weekday));

    switch (_filterDateRange) {
      case 'today':
        return tasks.where((task) => task.isDueToday).toList();
      case 'tomorrow':
        return tasks.where((task) {
          final taskDate = DateTime(task.dueDate.year, task.dueDate.month, task.dueDate.day);
          return taskDate.isAtSameMomentAs(tomorrow);
        }).toList();
      case 'week':
        return tasks.where((task) {
          final taskDate = DateTime(task.dueDate.year, task.dueDate.month, task.dueDate.day);
          return taskDate.isAfter(today.subtract(const Duration(days: 1))) && 
                 taskDate.isBefore(endOfWeek.add(const Duration(days: 1)));
        }).toList();
      case 'overdue':
        return tasks.where((task) => task.isOverdue).toList();
      default:
        return tasks;
    }
  }

  List<Task> _applySearchFilter(List<Task> tasks) {
    final query = _searchQuery.toLowerCase();
    return tasks.where((task) {
      return task.title.toLowerCase().contains(query) ||
             task.description.toLowerCase().contains(query) ||
             task.category.toLowerCase().contains(query) ||
             task.tags.any((tag) => tag.toLowerCase().contains(query));
    }).toList();
  }

  List<Task> _applySorting(List<Task> tasks) {
    switch (_sortBy) {
      case 'dueDate':
        tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
        break;
      case 'priority':
        tasks.sort((a, b) => b.priority.index.compareTo(a.priority.index));
        break;
      case 'title':
        tasks.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case 'createdAt':
        tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
    }
    return tasks;
  }

  List<Task> getTasksByPriority(TaskPriority priority) {
    return _tasks.where((task) => task.priority == priority).toList();
  }

  List<Task> getOverdueTasks() {
    return _tasks.where((task) => task.isOverdue).toList();
  }

  List<Task> getTasksDueToday() {
    return _tasks.where((task) => task.isDueToday).toList();
  }

  List<Task> getTasksByCategory(String category) {
    return _tasks.where((task) => task.category == category).toList();
  }

  List<Task> getTasksByTag(String tag) {
    return _tasks.where((task) => task.tags.contains(tag)).toList();
  }

  int getTaskCountByStatus(bool completed) {
    return _tasks.where((task) => task.isCompleted == completed).length;
  }

  int getTaskCountByPriority(TaskPriority priority) {
    return _tasks.where((task) => task.priority == priority).length;
  }

  double getCompletionRate() {
    if (_tasks.isEmpty) return 0.0;
    final completedCount = _tasks.where((task) => task.isCompleted).length;
    return (completedCount / _tasks.length) * 100;
  }

  Task? getTaskById(int id) {
    try {
      return _tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Task>> searchTasks(String query) async {
    return await _dbHelper.searchTasks(query);
  }
} 