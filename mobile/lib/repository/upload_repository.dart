import '../model/upload_response_model.dart';
import '../services/upload_service.dart';

class UploadRepository {
  final UploadService service = UploadService();

  Future<UploadResponseModel> upload(
    String localFilePath,
    double noiseReduction,
    double audioEnhancement,
  ) async {
    return await service.uploadFile(
      localFilePath,
      noiseReduction,
      audioEnhancement,
    );
  }

  /// Reprocess
  Future<UploadResponseModel> reprocess({
    required String backendOriginalFile,
    required double noiseReduction,
    required double audioEnhancement,
  }) async {
    return await service.reprocess(
      backendOriginalFile: backendOriginalFile,
      noiseReduction: noiseReduction,
      audioEnhancement: audioEnhancement,
    );
  }
}
