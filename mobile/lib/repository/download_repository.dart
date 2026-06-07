import '../services/download_service.dart';

class DownloadRepository {
  final DownloadService service = DownloadService();

  Future<void> download(String filename) async {
    await service.downloadFile(filename);
  }
}
