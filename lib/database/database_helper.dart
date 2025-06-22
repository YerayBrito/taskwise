import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'taskwise.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        category TEXT NOT NULL,
        isCompleted INTEGER NOT NULL,
        dueDate TEXT NOT NULL,
        priority INTEGER NOT NULL DEFAULT 1,
        tags TEXT,
        createdAt TEXT NOT NULL,
        completedAt TEXT
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE tasks ADD COLUMN priority INTEGER NOT NULL DEFAULT 1');
      await db.execute('ALTER TABLE tasks ADD COLUMN tags TEXT');
      await db.execute('ALTER TABLE tasks ADD COLUMN createdAt TEXT NOT NULL DEFAULT "${DateTime.now().toIso8601String()}"');
      await db.execute('ALTER TABLE tasks ADD COLUMN completedAt TEXT');
    }
  }

  Future<int> insertTask(Task task) async {
    Database db = await database;
    return await db.insert('tasks', task.toMap());
  }

  Future<List<Task>> getTasks() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tasks', orderBy: 'dueDate ASC');
    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }

  Future<List<Task>> searchTasks(String query) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'title LIKE ? OR description LIKE ? OR category LIKE ? OR tags LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%', '%$query%'],
      orderBy: 'dueDate ASC',
    );
    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }

  Future<int> updateTask(Task task) async {
    Database db = await database;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    Database db = await database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  Future<List<String>> getCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tasks', distinct: true, columns: ['category']);
    if (maps.isNotEmpty) {
      return maps.map((map) => map['category'] as String).toList();
    }
    return [];
  }

  Future<List<String>> getAllTags() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tasks', columns: ['tags']);
    Set<String> allTags = {};
    for (var map in maps) {
      if (map['tags'] != null && map['tags'].isNotEmpty) {
        allTags.addAll(map['tags'].split(','));
      }
    }
    return allTags.toList()..sort();
  }

  Future<Map<String, dynamic>> getTaskStatistics() async {
    final db = await database;
    final List<Map<String, dynamic>> allTasks = await db.query('tasks');
    
    int total = allTasks.length;
    int completed = allTasks.where((task) => task['isCompleted'] == 1).length;
    int pending = total - completed;
    int overdue = allTasks.where((task) {
      if (task['isCompleted'] == 1) return false;
      final dueDate = DateTime.parse(task['dueDate']);
      return dueDate.isBefore(DateTime.now());
    }).length;
    
    return {
      'total': total,
      'completed': completed,
      'pending': pending,
      'overdue': overdue,
      'completionRate': total > 0 ? (completed / total * 100).round() : 0,
    };
  }
} 