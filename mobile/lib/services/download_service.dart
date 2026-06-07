import 'dart:io';

import 'package:dio/dio.dart';

class DownloadService {
  final Dio dio = Dio();

  Future<void> downloadFile(String filename) async {
    String savePath = "${Directory.current.path}/$filename";

    await dio.download("http://127.0.0.1:8000/download/$filename", savePath);

    print("FILE SAVED:");
    print(savePath);
  }
}
