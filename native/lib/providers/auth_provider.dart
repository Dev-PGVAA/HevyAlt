import 'package:flutter/foundation.dart';

import '../models/auth_models.dart';
import '../models/user.dart';
import '../services/auth_exception.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService authService;

  UserModel? _user;
  String? _accessToken;
  bool _isLoading = false;
  String? _lastError;
  bool _needsProfileCompletion = false;

  AuthProvider({required this.authService});

  UserModel? get user => _user;
  bool get isAuthenticated => _accessToken != null && _user != null;
  bool get isLoading => _isLoading;
  String? get lastError => _lastError;
  bool get needsProfileCompletion => _needsProfileCompletion;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();
    try {
      // Do not block startup for long – proceed quickly if server is unreachable
      try {
        _user = await authService.getCurrentUser().timeout(
          const Duration(seconds: 2),
        );
      } catch (_) {
        _user = null;
      }
      // access token is stored securely; presence validated by endpoint above
      if (_user != null) {
        _accessToken = 'present';
        _needsProfileCompletion = false;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login({required String email, required String password}) async {
    _isLoading = true;
    _lastError = null;
    notifyListeners();
    try {
      final resp = await authService.login(
        LoginRequest(email: email, password: password),
      );
      _user = resp.user;
      _accessToken = resp.accessToken;
      _needsProfileCompletion = false;
      notifyListeners();
      return true;
    } catch (e) {
      if (e is AuthException) {
        _lastError = e.message;
      } else {
        _lastError = e.toString();
      }
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _lastError = null;
    notifyListeners();
    try {
      final resp = await authService.register(
        RegisterRequest(name: name, email: email, password: password),
      );
      _user = resp.user;
      _accessToken = resp.accessToken;
      _needsProfileCompletion = true;
      notifyListeners();
      return true;
    } catch (e) {
      if (e is AuthException) {
        _lastError = e.message;
      } else {
        _lastError = e.toString();
      }
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await authService.logout();
    _user = null;
    _accessToken = null;
    _needsProfileCompletion = false;
    notifyListeners();
  }

  void markProfileCompleted() {
    if (_needsProfileCompletion) {
      _needsProfileCompletion = false;
      notifyListeners();
    }
  }
}
