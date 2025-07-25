// database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('user_data.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT
      )
    ''');
  }

  Future<int> insertUserName(String name) async {
    final db = await instance.database;
    // Xóa các bản ghi cũ để đảm bảo chỉ có một tên
    await db.delete('users');
    return await db.insert(
      'users',
      {'name': name},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getUserName() async {
    final db = await instance.database;
    final result = await db.query('users', limit: 1);
    if (result.isNotEmpty) {
      return result.first['name'] as String?;
    }
    return null;
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}