import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'prediction_model.dart';
import 'dashboard_statistics.dart';
import 'statistics_data.dart';

class PredictionDatabase {
  PredictionDatabase._();

  static final PredictionDatabase instance = PredictionDatabase._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();

    final path = join(directory.path, 'prediction_history.db');

    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE prediction_history(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        disease TEXT NOT NULL,
        confidence REAL NOT NULL,
        imagePath TEXT NOT NULL,
        timestamp TEXT NOT NULL
      )
    ''');
  }

  /// Insert a prediction
  Future<int> insertPrediction(PredictionRecord prediction) async {
    final db = await database;

    return await db.insert(
      'prediction_history',
      prediction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get all predictions (latest first)
  Future<List<PredictionRecord>> getPredictions() async {
    final db = await database;

    final maps = await db.query(
      'prediction_history',
      orderBy: 'timestamp DESC',
    );

    return maps.map((e) => PredictionRecord.fromMap(e)).toList();
  }

  /// Delete one prediction
  Future<void> deletePrediction(int id) async {
    final db = await database;

    await db.delete('prediction_history', where: 'id = ?', whereArgs: [id]);
  }

  /// Delete all history
  Future<void> clearHistory() async {
    final db = await database;

    await db.delete('prediction_history');
  }

  /// Total predictions
  Future<int> getTotalPredictions() async {
    final db = await database;

    final result = await db.rawQuery(
      'SELECT COUNT(*) AS total FROM prediction_history',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Healthy predictions
  Future<int> getHealthyCount() async {
    final db = await database;

    final result = await db.rawQuery(
      "SELECT COUNT(*) AS total FROM prediction_history WHERE disease='Healthy'",
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Diseased predictions
  Future<int> getDiseaseCount() async {
    final total = await getTotalPredictions();
    final healthy = await getHealthyCount();

    return total - healthy;
  }

  Future<DashboardStatistics> getStatistics() async {
    final total = await getTotalPredictions();
    final healthy = await getHealthyCount();
    final diseased = total - healthy;

    return DashboardStatistics(
      total: total,
      healthy: healthy,
      diseased: diseased,
    );
  }

  Future<Map<String, int>> getDiseaseStatistics() async {
    final db = await database;

    final result = await db.rawQuery('''
    SELECT disease, COUNT(*) as total
    FROM prediction_history
    GROUP BY disease
  ''');

    final Map<String, int> data = {};

    for (final row in result) {
      data[row['disease'] as String] = row['total'] as int;
    }

    return data;
  }

  Future<StatisticsData> getStatisticsData() async {
    final total = await getTotalPredictions();
    final healthy = await getHealthyCount();
    final diseased = total - healthy;

    final diseases = await getDiseaseStatistics();

    return StatisticsData(
      total: total,
      healthy: healthy,
      diseased: diseased,
      diseaseCounts: diseases,
    );
  }
}
