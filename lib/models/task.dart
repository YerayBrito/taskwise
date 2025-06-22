enum TaskPriority { low, medium, high }

class Task {
  int? id;
  String title;
  String description;
  String category;
  bool isCompleted;
  DateTime dueDate;
  TaskPriority priority;
  List<String> tags;
  DateTime createdAt;
  DateTime? completedAt;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.isCompleted,
    required this.dueDate,
    this.priority = TaskPriority.medium,
    this.tags = const [],
    DateTime? createdAt,
    this.completedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  bool get isOverdue => !isCompleted && dueDate.isBefore(DateTime.now());
  
  bool get isDueToday {
    final now = DateTime.now();
    return !isCompleted && 
           dueDate.day == now.day && 
           dueDate.month == now.month && 
           dueDate.year == now.year;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'isCompleted': isCompleted ? 1 : 0,
      'dueDate': dueDate.toIso8601String(),
      'priority': priority.index,
      'tags': tags.join(','),
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      category: map['category'],
      isCompleted: map['isCompleted'] == 1,
      dueDate: DateTime.parse(map['dueDate']),
      priority: TaskPriority.values[map['priority'] ?? 1],
      tags: map['tags'] != null && map['tags'].isNotEmpty 
          ? map['tags'].split(',') 
          : [],
      createdAt: DateTime.parse(map['createdAt']),
      completedAt: map['completedAt'] != null 
          ? DateTime.parse(map['completedAt']) 
          : null,
    );
  }

  Task copyWith({
    int? id,
    String? title,
    String? description,
    String? category,
    bool? isCompleted,
    DateTime? dueDate,
    TaskPriority? priority,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
} 