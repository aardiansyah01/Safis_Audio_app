import '../../model/user_model.dart';
import '../data/api/auth_api.dart';

class AuthRepository {
  final AuthApi api = AuthApi();

  Future<String> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final response = await api.register(
      username: username,
      email: email,
      password: password,
    );

    return response["message"];
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await api.login(email: email, password: password);

    return UserModel.fromJson(response["user"]);
  }
}
