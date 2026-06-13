import '../../data/dtos/auth_dto.dart';

class User {
  final String id;
  final String email;
  final String fullName;
  final String studentId;
  final String institution;
  final UserRole role;

  const User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.studentId,
    required this.institution,
    required this.role,
  });

  String get initials {
    final parts = fullName.trim().split(' ');
    if (parts.length >= 2) return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    return fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';
  }

  factory User.fromDto(UserProfileDto dto) => User(
        id: dto.id,
        email: dto.email,
        fullName: dto.fullName,
        studentId: dto.studentId,
        institution: dto.institution,
        role: UserRole.fromString(dto.role),
      );
}

enum UserRole {
  scholar,
  staff,
  admin;

  static UserRole fromString(String value) => switch (value) {
        'staff' => UserRole.staff,
        'admin' => UserRole.admin,
        _ => UserRole.scholar,
      };

  String get displayLabel => switch (this) {
        UserRole.scholar => 'CADT Scholar',
        UserRole.staff => 'Staff',
        UserRole.admin => 'Admin',
      };
}
