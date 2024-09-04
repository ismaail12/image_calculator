// lib/services/database_storage_service.dart

import 'package:image_calculator/features/calculator/data/models/calculation_result.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DatabaseStorageService {
  Database? _database;

  Future<void> _initDatabase() async {
    if (_database != null) return;
    _database = await openDatabase(
      join(await getDatabasesPath(), 'results.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE results(id INTEGER PRIMARY KEY, input TEXT, result TEXT, path TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> storeToDatabaseStorage(CalculationResult calculation) async {
    await _initDatabase();
    await _database?.insert(
      'results',
      {
        'input': calculation.input,
        'result': calculation.result.toString(),
        'path': calculation.path,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    print(await readFromDatabaseStorage());
  }

  Future<List<CalculationResult>> readFromDatabaseStorage() async {
    await _initDatabase();
    final results = await _database?.query('results') ?? [];
    return results.map((result) {
      return CalculationResult(
        input: result['input'] as String,
        result: double.parse(result['result'] as String),
        path: result['path'] as String,
      );
    }).toList();
  }


}
