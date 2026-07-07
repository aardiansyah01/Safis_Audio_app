import 'package:dio/dio.dart';
import '../../config/api_config.dart';

class AuthApi {
  final Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
    ),
  );

  final String baseUrl = ApiConfig.baseUrl;

  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        "$baseUrl/auth/register",
        data: {"username": username, "email": email, "password": password},
      );

      return response.data;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["detail"] ?? e.message ?? "Register gagal",
      );
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        "$baseUrl/auth/login",
        data: {"email": email, "password": password},
      );

      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data["detail"] ?? e.message ?? "Login gagal");
    }
  }
}
