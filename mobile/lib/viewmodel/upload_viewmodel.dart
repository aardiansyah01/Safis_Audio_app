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
  String? selectedFilePath;

  String? enhancedFile;

  bool isLoading = false;
  bool isPlaying = false;
  bool isUploadSuccess = false;

  // AI SETTINGS

  double noiseReduction = 50;
  double audioEnhancement = 50;

  List<HistoryModel> histories = [];

  void setSelectedFile(String filename) {
    selectedFile = filename;
    notifyListeners();
  }

  void setSelectedFilePath(String path) {
    selectedFilePath = path;
    notifyListeners();
  }

  void setNoiseReduction(double value) {
    noiseReduction = value;
    notifyListeners();
  }

  void setAudioEnhancement(double value) {
    audioEnhancement = value;
    notifyListeners();
  }

  void resetProcessingState() {
    enhancedFile = null;
    isLoading = false;
    isPlaying = false;
    isUploadSuccess = false;
    status = "Belum upload";
    notifyListeners();
  }

  Future<bool> uploadFile(String path) async {
    try {
      isLoading = true;
      isUploadSuccess = false;
      status = "Uploading...";
      notifyListeners();

      final String result = await repository.upload(
        path,
        noiseReduction,
        audioEnhancement,
      );

      enhancedFile = result;

      await historyRepository.insertHistory(
        HistoryModel(
          originalFile: selectedFile,
          enhancedFile: result,
          createdAt: DateTime.now().toString(),
        ),
      );

      await loadHistory();

      status = "Upload berhasil: $result";
      isUploadSuccess = true;
      return true;
    } catch (e) {
      status = "Error upload: $e";
      isUploadSuccess = false;
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> downloadEnhancedFile() async {
    if (enhancedFile == null) return;

    try {
      status = "Downloading...";
      notifyListeners();

      await downloadRepository.download(enhancedFile!);

      status = "Download selesai";
    } catch (e) {
      status = "Download gagal: $e";
    }

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
