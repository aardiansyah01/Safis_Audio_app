import 'package:dio/dio.dart';

class UploadService {
  final Dio dio = Dio();

  Future<String> uploadFile(String filePath) async {
    try {
      print("START UPLOAD");

      String fileName = filePath.split('/').last;

      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(filePath, filename: fileName),
      });

      final response = await dio.post(
        "http://127.0.0.1:8000/upload",
        data: formData,
      );

      print("UPLOAD SUCCESS");
      print(response.data);
      print(response.data.runtimeType);
      print(response.data);
      print(response.data["enhanced_file"]);

      return response.data["enhanced_file"];
    } catch (e) {
      print("UPLOAD ERROR");
      print(e);

      rethrow;
    }
  }
}
