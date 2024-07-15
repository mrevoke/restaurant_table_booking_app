import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'my_db.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE records (
            table_no INTEGER PRIMARY KEY,
            person_name TEXT,
            foods TEXT,
            order_time TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertRecord(int tableNo, String personName, List<String> foods, String orderTime) async {
    final db = await database;
    await db.insert(
      'records',
      {
        'table_no': tableNo,
        'person_name': personName,
        'foods': jsonEncode(foods),
        'order_time': orderTime,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateRecord(int tableNo, String personName, List<String> foods, String orderTime) async {
    final db = await database;
    await db.update(
      'records',
      {
        'person_name': personName,
        'foods': jsonEncode(foods),
        'order_time': orderTime,
      },
      where: 'table_no = ?',
      whereArgs: [tableNo],
    );
  }

  Future<List<Map<String, dynamic>>> fetchRecords() async {
    final db = await database;
    return await db.query('records');
  }
}
