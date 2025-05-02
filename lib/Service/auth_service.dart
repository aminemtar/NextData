import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class AuthService {
  static const _channel = MethodChannel('com.example.postviewer/auth');

  Future<bool> login(String email, String password) async {
    try {
      final success = await _channel.invokeMethod('login', {
        'email': email,
        'password': password,
      });
      return success == true;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Login error: ${e.message}');
      }
      return false;
    }
  }

  Future<bool> signup(String email, String password) async {
    try {
      final success = await _channel.invokeMethod('signup', {
        'email': email,
        'password': password,
      });
      return success == true;
    } on PlatformException catch (e) {
      print('Signup error: ${e.message}');
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      final success = await _channel.invokeMethod('logout');
      return success == true;
    } on PlatformException catch (e) {
      print('Logout error: ${e.message}');
      return false;
    }
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      return await _channel.invokeMethod('getCurrentUser');
    } on PlatformException catch (e) {
      print('Get user error: ${e.message}');
      return null;
    }
  }

  Future<String?> getToken() async {
    try {
      final token = await _channel.invokeMethod<String>('getToken');
      return token;
    } on PlatformException catch (e) {
      print('Get token error: ${e.message}');
      return null;
    }
  }

  Future<void> clearToken() async {
    try {
      await _channel.invokeMethod('clearToken');
    } catch (e) {
      print('Failed to clear token: $e');
    }
  }
}
