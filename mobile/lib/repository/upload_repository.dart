import '../services/upload_service.dart';

class UploadRepository {
  final UploadService service = UploadService();

  Future<String> upload(
    String path,
    double noiseReduction,
    double audioEnhancement,
  ) async {
    return await service.uploadFile(path, noiseReduction, audioEnhancement);
  }
}
