import 'package:android_flutter_test/Service/auth_service.dart';
import 'package:android_flutter_test/views/login_screen.dart';

import 'package:flutter/material.dart';

import '../views/posts_list_screen.dart';

class AuthViewModel with ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isLoading = false;
  String error = '';

  Future<void> login({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    final success = await _authService.login(email, password);
    if (success) {
      fetchAndPrintToken();
      _setLoading(false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => PostListScreen()),
      );
    } else {
      error = 'Invalid email or password';
      _setLoading(false);
    }
  }

  Future<void> signup({
    required BuildContext context,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (password != confirmPassword) {
      error = 'Passwords do not match';
      notifyListeners();
      return;
    }

    _setLoading(true);
    final success = await _authService.signup(email, password);
    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
      _setLoading(false);
    } else {
      error = 'Signup failed. Please try again.';
      _setLoading(false);
    }
  }

  void clearError() {
    error = '';
    notifyListeners();
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void fetchAndPrintToken() async {
    final token = await _authService.getToken();
    if (token != null) {
      print('Firebase Token: $token');
    } else {
      print('No token found.');
    }
  }

  Future<bool> hasValidToken() async {
    final token = await _authService.getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> logout(BuildContext context) async {
    await _authService.clearToken();
  }
}
