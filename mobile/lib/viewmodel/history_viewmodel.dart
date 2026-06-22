import 'package:flutter/material.dart';

import '../model/history_model.dart';
import '../repository/history_repository.dart';

class HistoryViewModel extends ChangeNotifier {
  final HistoryRepository repository = HistoryRepository();

  List<HistoryModel> histories = [];

  List<HistoryModel> filteredHistories = [];

  Future<void> loadHistory() async {
    histories = await repository.getHistory();

    filteredHistories = List.from(histories);

    notifyListeners();
  }

  void searchHistory(String keyword) {
    if (keyword.isEmpty) {
      filteredHistories = List.from(histories);
    } else {
      filteredHistories = histories.where((history) {
        return history.originalFile.toLowerCase().contains(
          keyword.toLowerCase(),
        );
      }).toList();
    }

    notifyListeners();
  }

  Future<void> deleteHistory(int id) async {
    await repository.deleteHistory(id);

    await loadHistory();
  }
}
