import 'package:flutter/material.dart';

import '../repository/auth_repository.dart';
import '../model/user_model.dart';
import '../services/session_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository repository = AuthRepository();

  bool isLoading = false;

  bool isLoggedIn = false;

  String status = "";

  UserModel? currentUser;

  Future<bool> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      status = await repository.register(
        username: username,
        email: email,
        password: password,
      );

      return true;
    } catch (e) {
      status = e.toString().replaceFirst("Exception: ", "");
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login({required String email, required String password}) async {
    try {
      isLoading = true;
      notifyListeners();

      currentUser = await repository.login(email: email, password: password);

      isLoggedIn = true;

      status = "Login berhasil";

      await SessionService.saveLogin(
        username: currentUser!.username,
        email: currentUser!.email,
      );

      return true;
    } catch (e) {
      status = e.toString().replaceFirst("Exception: ", "");

      isLoggedIn = false;

      currentUser = null;

      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await SessionService.logout();

    currentUser = null;

    isLoggedIn = false;

    status = "";

    await loadSession();
  }

  void clearStatus() {
    status = "";
    notifyListeners();
  }

  Future<void> loadSession() async {
    isLoggedIn = await SessionService.isLoggedIn();

    if (isLoggedIn) {
      currentUser = UserModel(
        username: await SessionService.getUsername(),
        email: await SessionService.getEmail(),
      );
    } else {
      currentUser = null;
    }

    notifyListeners();
  }
}
