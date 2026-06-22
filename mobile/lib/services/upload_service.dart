import 'package:dio/dio.dart';

class UploadService {
  final Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(minutes: 2),
      receiveTimeout: const Duration(minutes: 10),
    ),
  );

  Future<String> uploadFile(
    String filePath,
    double noiseReduction,
    double audioEnhancement,
  ) async {
    try {
      print("START UPLOAD");
      print("FILE PATH: $filePath");
      print("NOISE: $noiseReduction");
      print("ENHANCEMENT: $audioEnhancement");

      String fileName = filePath.split('/').last;

      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(filePath, filename: fileName),
        "noise_reduction": noiseReduction.toInt(),
        "audio_enhancement": audioEnhancement.toInt(),
      });

      print("POSTING TO BACKEND...");

      final response = await dio.post(
        "http://127.0.0.1:8000/upload",
        data: formData,
        options: Options(headers: {"Accept": "application/json"}),
      );

      print("UPLOAD SUCCESS");
      print("STATUS CODE: ${response.statusCode}");
      print("RESPONSE DATA: ${response.data}");

      return response.data["enhanced_file"];
    } on DioException catch (e) {
      print("DIO ERROR");
      print("TYPE: ${e.type}");
      print("MESSAGE: ${e.message}");
      print("RESPONSE: ${e.response?.data}");
      rethrow;
    } catch (e) {
      print("UPLOAD ERROR");
      print(e);
      rethrow;
    }
  }
}
