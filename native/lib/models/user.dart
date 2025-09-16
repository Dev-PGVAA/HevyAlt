class UserModel {
  final String id;
  final String email;
  final String name;
  final String? avatar;
  final String role;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      role: (json['role'] ?? 'USER').toString(),
      avatar: json['avatar'] as String?,
    );
  }
}
