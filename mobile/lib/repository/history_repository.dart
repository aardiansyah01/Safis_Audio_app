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

    return maps.map((e) => HistoryModel.fromMap(e)).toList();
  }

  Future<void> updateHistory(HistoryModel history) async {
    final Database db = await DatabaseHelper.database;

    await db.update(
      'history',
      history.toMap(),
      where: 'id = ?',
      whereArgs: [history.id],
    );
  }

  Future<void> deleteHistory(int id) async {
    final Database db = await DatabaseHelper.database;

    await db.delete('history', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<HistoryModel>> searchHistory(String keyword) async {
    final Database db = await DatabaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'history',
      where: 'originalFile LIKE ?',
      whereArgs: ['%$keyword%'],
      orderBy: 'id DESC',
    );

    return maps.map((e) => HistoryModel.fromMap(e)).toList();
  }
}
