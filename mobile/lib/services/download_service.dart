import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path_provider/path_provider.dart';

class DownloadService {
  final Dio _dio = Dio();

  static const String baseUrl = "http://10.0.2.2:8000";

  Future<bool> downloadFile(String filename) async {
    try {
      final Directory tempDir = await getTemporaryDirectory();

      final String tempPath = "${tempDir.path}/$filename";

      await _dio.download("$baseUrl/download/$filename", tempPath);

      final params = SaveFileDialogParams(sourceFilePath: tempPath);

      final savedPath = await FlutterFileDialog.saveFile(params: params);

      final file = File(tempPath);

      if (await file.exists()) {
        await file.delete();
      }

      return savedPath != null;
    } catch (e) {
      print("DOWNLOAD ERROR:");
      print(e);

      return false;
    }
  }
}
