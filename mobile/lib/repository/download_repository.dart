import '../services/download_service.dart';

class DownloadRepository {
  final DownloadService service = DownloadService();

  Future<bool> download(String filename) async {
    return await service.downloadFile(filename);
  }
}
