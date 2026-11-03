// UC01, UC02: UserSession data model
class UserSession {
  final String id;
  final String fullName;
  final String email;
  final String role; // 'Owner' or 'Admin'
  final String token;

  const UserSession({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.token,
  });

  bool get isAdmin => role == 'Admin';
  bool get isOwner => role == 'Owner';

  factory UserSession.fromJson(Map<String, dynamic> json, String token) {
    final user = json['user'] as Map<String, dynamic>? ?? json;
    return UserSession(
      id: user['id']?.toString() ?? user['_id']?.toString() ?? '',
      fullName: user['fullName']?.toString() ?? '',
      email: user['email']?.toString() ?? '',
      role: user['role']?.toString() ?? 'Owner',
      token: token,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'email': email,
        'role': role,
        'token': token,
      };
}
