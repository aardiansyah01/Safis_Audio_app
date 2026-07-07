import 'package:dio/dio.dart';

import '../model/upload_response_model.dart';
import '../config/api_config.dart';

class UploadService {
  final Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(minutes: 2),
      receiveTimeout: const Duration(minutes: 10),
    ),
  );

  final String baseUrl = ApiConfig.baseUrl;

  Future<UploadResponseModel> uploadFile(
    String filePath,
    double noiseReduction,
    double audioEnhancement,
  ) async {
    try {
      final String fileName = filePath.split('/').last;

      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(filePath, filename: fileName),
        "noise_reduction": noiseReduction.toInt(),
        "audio_enhancement": audioEnhancement.toInt(),
      });

      final response = await dio.post(
        "$baseUrl/upload",
        data: formData,
        options: Options(headers: {"Accept": "application/json"}),
      );

      return UploadResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data.toString() ?? e.message ?? "Upload gagal",
      );
    }
  }

  /// REPROCESS
  Future<UploadResponseModel> reprocess({
    required String backendOriginalFile,
    required double noiseReduction,
    required double audioEnhancement,
  }) async {
    try {
      final formData = FormData.fromMap({
        "original_file": backendOriginalFile,
        "noise_reduction": noiseReduction.toInt(),
        "audio_enhancement": audioEnhancement.toInt(),
      });

      final response = await dio.post(
        "$baseUrl/reprocess",
        data: formData,
        options: Options(headers: {"Accept": "application/json"}),
      );

      return UploadResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data.toString() ?? e.message ?? "Reprocess gagal",
      );
    }
  }
}
