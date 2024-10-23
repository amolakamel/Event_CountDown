import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class EventDatabaseHelper {
  static final EventDatabaseHelper _instance = EventDatabaseHelper._internal();
  factory EventDatabaseHelper() => _instance;
  static Database? _database;

  EventDatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'events.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Create the events table
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE events (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        date TEXT
      )
''');
  }
}