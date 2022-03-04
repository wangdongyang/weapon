import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'package:weapon/db/history_dao.dart';

class LocalDb {
  Database? _database;

  LocalDb._();

  static LocalDb instance = LocalDb._();

  late HistoryDao _historyDao;

  HistoryDao get historyDao => _historyDao;

  Database get db => _database!;

  Future<void> initDb({String name = "music.db"}) async {
    if (_database != null) return;
    String databasesPath = await getDatabasesPath();
    String dbPath = path.join(databasesPath, name);

    _database = await openDatabase(dbPath);

    _historyDao = HistoryDao(_database!);

    print('初始化数据库....');
  }

  Future<void> closeDb() async {
    await _database?.close();
    _database = null;
  }
}
