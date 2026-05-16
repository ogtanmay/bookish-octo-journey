import 'package:hive_flutter/hive_flutter.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalStorageService {
  LocalStorageService._();

  static final instance = LocalStorageService._();

  static const _boxName = 'grindos_box';
  static const _stateKey = 'dashboard_state';
  Box<dynamic>? _box;
  Database? _db;

  Future<void> initialize() async {
    await Hive.initFlutter();
    _box = await Hive.openBox<dynamic>(_boxName);

    final dbPath = await getDatabasesPath();
    _db = await openDatabase(
      join(dbPath, 'grindos.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE analytics(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            metric TEXT NOT NULL,
            value REAL NOT NULL,
            createdAt TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Map<dynamic, dynamic>? loadState() {
    final value = _box?.get(_stateKey);
    if (value is Map) {
      return value;
    }
    return null;
  }

  Future<void> saveState(Map<String, dynamic> payload) async {
    await _box?.put(_stateKey, payload);
  }

  Future<void> addAnalytics(String metric, double value) async {
    await _db?.insert('analytics', {
      'metric': metric,
      'value': value,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }
}
