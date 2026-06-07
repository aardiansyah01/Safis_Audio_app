import 'package:flutter/material.dart';

import '../repository/upload_repository.dart';
import '../repository/download_repository.dart';
import '../repository/audio_player_repository.dart';
import '../repository/history_repository.dart';
import '../model/history_model.dart';

class UploadViewModel extends ChangeNotifier {
  UploadViewModel() {
    loadHistory();
  }

  final UploadRepository repository = UploadRepository();
  final DownloadRepository downloadRepository = DownloadRepository();
  final AudioPlayerRepository audioRepository = AudioPlayerRepository();
  final HistoryRepository historyRepository = HistoryRepository();

  String status = "Belum upload";
  String selectedFile = "Tidak ada file dipilih";

  String? enhancedFile;

  bool isLoading = false;
  bool isPlaying = false;

  List<HistoryModel> histories = [];

  Future<void> uploadFile(String path) async {
    try {
      isLoading = true;
      status = "Uploading...";
      notifyListeners();

      String result = await repository.upload(path);

      enhancedFile = result;

      await historyRepository.insertHistory(
        HistoryModel(
          originalFile: selectedFile,
          enhancedFile: result,
          createdAt: DateTime.now().toString(),
        ),
      );

      status = "Upload berhasil: $result";
    } catch (e) {
      status = "Error upload: $e";
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> downloadEnhancedFile() async {
    if (enhancedFile == null) return;

    try {
      status = "Downloading...";
      notifyListeners();

      await downloadRepository.download(enhancedFile!);

      status = "Download selesai";
    } catch (e) {
      status = "Download gagal";
    }

    notifyListeners();
  }

  void setSelectedFile(String filename) {
    selectedFile = filename;
    notifyListeners();
  }

  Future<void> playEnhancedAudio() async {
    if (enhancedFile == null) return;

    try {
      await audioRepository.play(
        "http://127.0.0.1:8000/download/$enhancedFile",
      );

      isPlaying = true;

      notifyListeners();
    } catch (e) {
      status = "Gagal memutar audio";

      notifyListeners();
    }
  }

  Future<void> stopAudio() async {
    await audioRepository.stop();

    isPlaying = false;

    notifyListeners();
  }

  Future<void> loadHistory() async {
    histories = await historyRepository.getHistory();

    notifyListeners();
  }
}
