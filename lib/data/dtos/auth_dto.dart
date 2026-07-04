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

class RoleDto {
  final String id;
  final String name;

  const RoleDto({required this.id, required this.name});

  factory RoleDto.fromJson(Map<String, dynamic> json) => RoleDto(
        id: json['id'] as String,
        name: json['name'] as String,
      );
}

class SchoolDto {
  final String id;
  final String name;

  const SchoolDto({required this.id, required this.name});

  factory SchoolDto.fromJson(Map<String, dynamic> json) => SchoolDto(
        id: json['id'] as String,
        name: json['name'] as String,
      );
}

/// Mirrors the backend `User` entity (backend `src/modules/users/entities/user.entity.ts`),
/// as returned by `GET /users/me` and embedded in the `user` field of auth responses.
class UserProfileDto {
  final String id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? avatarUrl;
  final String status;
  final RoleDto? role;
  final SchoolDto? school;

  const UserProfileDto({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.avatarUrl,
    required this.status,
    this.role,
    this.school,
  });

  factory UserProfileDto.fromJson(Map<String, dynamic> json) => UserProfileDto(
        id: json['id'] as String,
        email: json['email'] as String,
        firstName: json['first_name'] as String?,
        lastName: json['last_name'] as String?,
        phone: json['phone'] as String?,
        avatarUrl: json['avatar_url'] as String?,
        status: json['status'] as String? ?? 'active',
        role: json['role'] != null
            ? RoleDto.fromJson(json['role'] as Map<String, dynamic>)
            : null,
        school: json['school'] != null
            ? SchoolDto.fromJson(json['school'] as Map<String, dynamic>)
            : null,
      );
}
