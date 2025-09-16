import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/auth_models.dart';
import '../models/user.dart';
import 'api_client.dart';
import 'auth_exception.dart';

class AuthService {
  static const _secureStorage = FlutterSecureStorage();
  static const _accessTokenKey = 'access_token';

  final ApiClient api;

  AuthService(this.api) {
    // Attach interceptor to include Authorization header automatically
    api.dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _secureStorage.read(key: _accessTokenKey);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (e, handler) async {
          // If unauthorized - try to refresh
          if (e.response?.statusCode == 401) {
            final refreshed = await _tryRefreshToken();
            if (refreshed) {
              // repeat original request with new token
              final token = await _secureStorage.read(key: _accessTokenKey);
              if (token != null) {
                e.requestOptions.headers['Authorization'] = 'Bearer $token';
              }
              try {
                final cloneReq = await api.dio.fetch(e.requestOptions);
                return handler.resolve(cloneReq);
              } catch (err) {
                return handler.reject(err as DioException);
              }
            }
          }
          handler.next(e);
        },
      ),
    );
  }

  Future<bool> _tryRefreshToken() async {
    try {
      final res = await api.dio.post('/auth/login/access-token');
      final data = res.data as Map<String, dynamic>;
      final auth = AuthResponse.fromJson(data);
      await _secureStorage.write(key: _accessTokenKey, value: auth.accessToken);
      return true;
    } catch (_) {
      await logout();
      return false;
    }
  }

  Future<AuthResponse> login(LoginRequest body) async {
    try {
      final res = await api.dio.post('/auth/login', data: body.toJson());
      final data = res.data as Map<String, dynamic>;
      final auth = AuthResponse.fromJson(data);
      await _secureStorage.write(key: _accessTokenKey, value: auth.accessToken);
      return auth;
    } on DioException catch (e) {
      final msg = e.response?.data is Map<String, dynamic>
          ? ((e.response!.data['message'] ?? e.message) as String? ??
                'Login error')
          : (e.message ?? 'Login error');
      throw AuthException(msg);
    }
  }

  Future<AuthResponse> register(RegisterRequest body) async {
    try {
      final res = await api.dio.post('/auth/register', data: body.toJson());
      final data = res.data as Map<String, dynamic>;
      final auth = AuthResponse.fromJson(data);
      await _secureStorage.write(key: _accessTokenKey, value: auth.accessToken);
      return auth;
    } on DioException catch (e) {
      final msg = e.response?.data is Map<String, dynamic>
          ? ((e.response!.data['message'] ?? e.message) as String? ??
                'Registration error')
          : (e.message ?? 'Registration error');
      throw AuthException(msg);
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final res = await api.dio.get('/user/profile');
      return UserModel.fromJson(res.data as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await api.dio.post('/auth/logout');
    } catch (_) {}
    await _secureStorage.delete(key: _accessTokenKey);
    try {
      await api.cookieJar.deleteAll();
    } catch (_) {}
  }
}
