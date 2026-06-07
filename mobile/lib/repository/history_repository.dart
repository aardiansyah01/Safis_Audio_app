import 'package:sqflite/sqflite.dart';

import '../data/database/database_helper.dart';
import '../model/history_model.dart';

class HistoryRepository {
  Future<void> insertHistory(HistoryModel history) async {
    final Database db = await DatabaseHelper.database;

    await db.insert('history', history.toMap());
  }

  Future<List<HistoryModel>> getHistory() async {
    final Database db = await DatabaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'history',
      orderBy: 'id DESC',
    );

    return List.generate(maps.length, (i) => HistoryModel.fromMap(maps[i]));
  }
}
