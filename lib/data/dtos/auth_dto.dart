class AuthTokenDto {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;

  const AuthTokenDto({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  factory AuthTokenDto.fromJson(Map<String, dynamic> json) => AuthTokenDto(
        accessToken: json['access_token'] as String,
        refreshToken: json['refresh_token'] as String,
        expiresIn: json['expires_in'] as int,
      );

  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
        'refresh_token': refreshToken,
        'expires_in': expiresIn,
      };
}

class UserProfileDto {
  final String id;
  final String email;
  final String fullName;
  final String studentId;
  final String institution;
  final String role;

  const UserProfileDto({
    required this.id,
    required this.email,
    required this.fullName,
    required this.studentId,
    required this.institution,
    required this.role,
  });

  factory UserProfileDto.fromJson(Map<String, dynamic> json) => UserProfileDto(
        id: json['id'] as String,
        email: json['email'] as String,
        fullName: json['full_name'] as String,
        studentId: json['student_id'] as String,
        institution: json['institution'] as String,
        role: json['role'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'full_name': fullName,
        'student_id': studentId,
        'institution': institution,
        'role': role,
      };
}
