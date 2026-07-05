import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../repository/upload_repository.dart';
import '../repository/download_repository.dart';
import '../repository/audio_player_repository.dart';
import '../repository/history_repository.dart';
import '../repository/video_player_repository.dart';
import '../model/history_model.dart';
import '../model/upload_response_model.dart';

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
  String? selectedLocalPath;
  String? selectedBackendFile;

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

  HistoryModel? currentHistoryProject;

  bool get isReprocessing => currentHistoryProject != null;

  void setSelectedFile(String filename) {
    selectedFile = filename;
    notifyListeners();
  }

  void setSelectedLocalPath(String path) {
    selectedLocalPath = path;
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
    final path = selectedLocalPath?.toLowerCase();

    if (path == null) return false;

    return path.endsWith(".mp4");
  }

  bool get isProcessingVideo {
    if (selectedLocalPath != null) {
      return selectedLocalPath!.toLowerCase().endsWith(".mp4");
    }

    if (selectedBackendFile != null) {
      return selectedBackendFile!.toLowerCase().endsWith(".mp4");
    }

    return false;
  }

  bool get isSelectedFileAudio {
    final path = selectedLocalPath?.toLowerCase();

    if (path == null) return false;

    return path.endsWith(".mp3") || path.endsWith(".wav");
  }

  bool get isProcessingAudio {
    if (selectedLocalPath != null) {
      final path = selectedLocalPath!.toLowerCase();
      return path.endsWith(".mp3") || path.endsWith(".wav");
    }

    if (selectedBackendFile != null) {
      final path = selectedBackendFile!.toLowerCase();
      return path.endsWith(".mp3") || path.endsWith(".wav");
    }

    return false;
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

  String? get originalFileUrl {
    if (selectedBackendFile == null) return null;

    return "http://127.0.0.1:8000/uploads/$selectedBackendFile";
  }

  // PROCESSING PREVIEW LOGIk
  Future<void> initializeProcessingPreview() async {
    if (hasProcessingPreviewInitialized) return;

    bool isVideo = false;

    if (selectedLocalPath != null) {
      isVideo = selectedLocalPath!.toLowerCase().endsWith(".mp4");
    } else if (selectedBackendFile != null) {
      isVideo = selectedBackendFile!.toLowerCase().endsWith(".mp4");
    }

    if (!isVideo) {
      hasProcessingPreviewInitialized = true;
      notifyListeners();
      return;
    }

    try {
      isProcessingPreviewLoading = true;
      notifyListeners();

      if (selectedLocalPath != null) {
        processingVideoController = await videoRepository.createController(
          selectedLocalPath!,
        );
      } else if (originalFileUrl != null) {
        processingVideoController = await videoRepository
            .createNetworkController(originalFileUrl!);
      }

      if (processingVideoController != null) {
        processingVideoController!.addListener(() {
          notifyListeners();
        });

        await processingVideoController!.setLooping(true);
        await processingVideoController!.setVolume(1.0);
      }

      hasProcessingPreviewInitialized = true;
    } catch (e) {
      debugPrint("Video preview init error : $e");
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

    selectedFile = "Tidak ada file dipilih";

    selectedLocalPath = null;

    selectedBackendFile = null;

    currentHistoryProject = null;

    enhancedFile = null;

    isLoading = false;

    isPlaying = false;

    isUploadSuccess = false;

    status = "Belum upload";

    noiseReduction = 50;

    audioEnhancement = 50;

    notifyListeners();
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

  void loadHistoryProject(HistoryModel history) {
    currentHistoryProject = history;

    selectedFile = history.originalFile;

    selectedLocalPath = null;

    selectedBackendFile = history.originalPath;

    enhancedFile = history.enhancedFile;

    noiseReduction = history.noiseReduction;

    audioEnhancement = history.audioEnhancement;

    status = "Belum upload";

    notifyListeners();
  }

  void clearHistoryProject() {
    currentHistoryProject = null;
    selectedBackendFile = null;
    notifyListeners();
  }

  Future<bool> processCurrentProject() async {
    try {
      isLoading = true;
      isUploadSuccess = false;
      status = "Uploading...";
      notifyListeners();

      if (!isReprocessing && selectedLocalPath == null) {
        status = "File belum dipilih";
        notifyListeners();
        return false;
      }

      if (isReprocessing && selectedBackendFile == null) {
        status = "Project tidak ditemukan";
        notifyListeners();
        return false;
      }

      UploadResponseModel result;

      debugPrint("========== REPROCESS ==========");
      debugPrint("selectedBackendFile : $selectedBackendFile");
      debugPrint("selectedLocalPath   : $selectedLocalPath");
      debugPrint(
        "currentHistory      : ${currentHistoryProject?.originalPath}",
      );
      debugPrint("===============================");

      if (isReprocessing) {
        result = await repository.reprocess(
          backendOriginalFile: selectedBackendFile!,
          noiseReduction: noiseReduction,
          audioEnhancement: audioEnhancement,
        );
      } else {
        result = await repository.upload(
          selectedLocalPath!,
          noiseReduction,
          audioEnhancement,
        );
      }

      enhancedFile = result.enhancedFile;

      if (!isReprocessing) {
        await historyRepository.insertHistory(
          HistoryModel(
            originalFile: result.originalName,
            originalPath: result.storedOriginalFile,
            enhancedFile: result.enhancedFile,
            noiseReduction: result.noiseReduction,
            audioEnhancement: result.audioEnhancement,
            createdAt: DateTime.now().toIso8601String(),
          ),
        );
      } else {
        await historyRepository.updateHistory(
          HistoryModel(
            id: currentHistoryProject!.id,
            originalFile: currentHistoryProject!.originalFile,
            originalPath: currentHistoryProject!.originalPath,
            enhancedFile: result.enhancedFile,
            noiseReduction: noiseReduction,
            audioEnhancement: audioEnhancement,
            createdAt: currentHistoryProject!.createdAt,
          ),
        );

        currentHistoryProject = HistoryModel(
          id: currentHistoryProject!.id,
          originalFile: currentHistoryProject!.originalFile,
          originalPath: currentHistoryProject!.originalPath,
          enhancedFile: result.enhancedFile,
          noiseReduction: noiseReduction,
          audioEnhancement: audioEnhancement,
          createdAt: currentHistoryProject!.createdAt,
        );
      }

      await loadHistory();

      status = "Success";
      isUploadSuccess = true;

      return true;
    } catch (e) {
      status = e.toString();
      isUploadSuccess = false;
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
