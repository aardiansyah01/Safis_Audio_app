import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../repository/upload_repository.dart';
import '../repository/download_repository.dart';
import '../repository/audio_player_repository.dart';
import '../repository/history_repository.dart';
import '../repository/video_player_repository.dart';
import '../model/history_model.dart';

class UploadViewModel extends ChangeNotifier {
  UploadViewModel() {
    loadHistory();
  }

  final UploadRepository repository = UploadRepository();
  final DownloadRepository downloadRepository = DownloadRepository();
  final AudioPlayerRepository audioRepository = AudioPlayerRepository();
  final VideoPlayerRepository videoRepository = VideoPlayerRepository();
  final HistoryRepository historyRepository = HistoryRepository();

  String status = "Belum upload";
  String selectedFile = "Tidak ada file dipilih";
  String? selectedFilePath;

  String? enhancedFile;

  bool isLoading = false;
  bool isPlaying = false;
  bool isUploadSuccess = false;

  // PROCESSING PREVIEW STATE
  VideoPlayerController? processingVideoController;
  bool isProcessingPreviewLoading = false;
  bool isProcessingVideoPlaying = false;
  bool hasProcessingPreviewInitialized = false;

  // RESULT PREVIEW STATE
  VideoPlayerController? resultVideoController;
  bool isResultPreviewLoading = false;
  bool isResultVideoPlaying = false;
  bool hasResultPreviewInitialized = false;

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

  // FILE TYPE CEK
  bool get isSelectedFileVideo {
    final path = selectedFilePath?.toLowerCase();
    if (path == null) return false;
    return path.endsWith('.mp4');
  }

  bool get isSelectedFileAudio {
    final path = selectedFilePath?.toLowerCase();
    if (path == null) return false;
    return path.endsWith('.mp3') || path.endsWith('.wav');
  }

  bool get isEnhancedFileVideo {
    final file = enhancedFile?.toLowerCase();
    if (file == null) return false;
    return file.endsWith('.mp4');
  }

  bool get isEnhancedFileAudio {
    final file = enhancedFile?.toLowerCase();
    if (file == null) return false;
    return file.endsWith('.mp3') || file.endsWith('.wav');
  }

  String? get enhancedFileUrl {
    if (enhancedFile == null) return null;
    return "http://127.0.0.1:8000/download/$enhancedFile";
  }

  // PROCESSING PREVIEW LOGIk
  Future<void> initializeProcessingPreview() async {
    if (selectedFilePath == null) return;
    if (hasProcessingPreviewInitialized) return;

    if (!isSelectedFileVideo) {
      hasProcessingPreviewInitialized = true;
      notifyListeners();
      return;
    }

    try {
      isProcessingPreviewLoading = true;
      notifyListeners();

      processingVideoController = await videoRepository.createController(
        selectedFilePath!,
      );

      hasProcessingPreviewInitialized = true;
    } catch (e) {
      debugPrint("Video preview init error: $e");
    } finally {
      isProcessingPreviewLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleProcessingVideoPreview() async {
    final controller = processingVideoController;
    if (controller == null || !controller.value.isInitialized) return;

    if (controller.value.isPlaying) {
      await videoRepository.pause(controller);
      isProcessingVideoPlaying = false;
    } else {
      await videoRepository.play(controller);
      isProcessingVideoPlaying = true;
    }

    notifyListeners();
  }

  Future<void> disposeProcessingPreview({bool notify = true}) async {
    await videoRepository.dispose(processingVideoController);
    processingVideoController = null;
    isProcessingPreviewLoading = false;
    isProcessingVideoPlaying = false;
    hasProcessingPreviewInitialized = false;

    if (notify) {
      notifyListeners();
    }
  }

  // RESULT PREVIEW LOGIC

  Future<void> initializeResultPreview() async {
    if (enhancedFileUrl == null) return;
    if (hasResultPreviewInitialized) return;

    if (!isEnhancedFileVideo) {
      hasResultPreviewInitialized = true;
      notifyListeners();
      return;
    }

    try {
      isResultPreviewLoading = true;
      notifyListeners();

      resultVideoController = await videoRepository.createNetworkController(
        enhancedFileUrl!,
      );

      hasResultPreviewInitialized = true;
    } catch (e) {
      debugPrint("Result video preview init error: $e");
    } finally {
      isResultPreviewLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleResultVideoPreview() async {
    final controller = resultVideoController;
    if (controller == null || !controller.value.isInitialized) return;

    if (controller.value.isPlaying) {
      await videoRepository.pause(controller);
      isResultVideoPlaying = false;
    } else {
      await videoRepository.play(controller);
      isResultVideoPlaying = true;
    }

    notifyListeners();
  }

  Future<void> disposeResultPreview({bool notify = true}) async {
    await videoRepository.dispose(resultVideoController);
    resultVideoController = null;
    isResultPreviewLoading = false;
    isResultVideoPlaying = false;
    hasResultPreviewInitialized = false;

    if (notify) {
      notifyListeners();
    }
  }

  // RESET STATE
  Future<void> resetProcessingState() async {
    await stopAudio();
    await disposeProcessingPreview(notify: false);
    await disposeResultPreview(notify: false);

    enhancedFile = null;
    isLoading = false;
    isPlaying = false;
    isUploadSuccess = false;
    status = "Belum upload";

    notifyListeners();
  }

  // UPLOAD / PROCESS
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

  // DOWNLOAD
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

  // AUDIO PLAYBACK RESULT
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
