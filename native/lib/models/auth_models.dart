import 'user.dart';

class AuthResponse {
  final UserModel user;
  final String accessToken;

  const AuthResponse({required this.user, required this.accessToken});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      accessToken: json['accessToken'] as String,
    );
  }
}

class LoginRequest {
  final String email;
  final String password;

  const LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}

class RegisterRequest {
  final String name;
  final String email;
  final String password;

  const RegisterRequest({
    required this.name,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'password': password,
  };
}
