import '../services/upload_service.dart';

class UploadRepository {
  final UploadService service = UploadService();

  Future<String> upload(String path) async {
    return await service.uploadFile(path);
  }
}
