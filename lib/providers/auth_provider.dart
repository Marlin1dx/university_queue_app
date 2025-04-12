import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:university_queue_app/api/api_service.dart';
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isAdmin = false;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isAuthenticated => _isAuthenticated;
  bool get isAdmin => _isAdmin;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    checkAuthStatus(); 
  }

  Future<void> login(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await ApiService().login(email, password);
      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final token = responseBody['access_token'] ?? responseBody['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', token);
        
        _updateAuthState(token);
      } else {
        _handleError(responseBody['error'] ?? 'Ошибка авторизации');
      }
    } catch (e) {
      _handleError(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _updateAuthState(String? token) {
    if (token == null) {
      _isAuthenticated = false;
      _isAdmin = false;
      return;
    }

    _isAuthenticated = true;
    _isAdmin = _checkAdminRole(token);
    notifyListeners();
  }

  bool _checkAdminRole(String token) {
    try {
      final decodedToken = JwtDecoder.decode(token);
      return decodedToken['is_admin'] ?? false; 
    } catch (e) {
      return false;
    }
  }

  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    _updateAuthState(token);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    _isAuthenticated = false;
    _isAdmin = false;
    notifyListeners();
  }

  void _handleError(String message) {
    _errorMessage = message;
    _isAuthenticated = false;
    _isAdmin = false;
    notifyListeners();
    throw Exception(message);
  }
}