import '../../data/dtos/auth_dto.dart';

class User {
  final String id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? avatarUrl;
  final String? schoolName;
  final UserRole role;

  const User({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.avatarUrl,
    this.schoolName,
    required this.role,
  });

  String get fullName {
    final name = [
      firstName,
      lastName,
    ].where((p) => p != null && p.isNotEmpty).join(' ');
    return name.isNotEmpty ? name : email;
  }

  String get initials {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';
  }

  factory User.fromDto(UserProfileDto dto) => User(
        id: dto.id,
        email: dto.email,
        firstName: dto.firstName,
        lastName: dto.lastName,
        phone: dto.phone,
        avatarUrl: dto.avatarUrl,
        schoolName: dto.school?.name,
        role: UserRole.fromString(dto.role?.name),
      );
}

enum UserRole {
  student,
  staff,
  manager,
  systemAdmin;

  static UserRole fromString(String? value) => switch (value) {
        'staff' => UserRole.staff,
        'manager' => UserRole.manager,
        'system-admin' => UserRole.systemAdmin,
        _ => UserRole.student,
      };

  String get displayLabel => switch (this) {
        UserRole.student => 'Student',
        UserRole.staff => 'Staff',
        UserRole.manager => 'Manager',
        UserRole.systemAdmin => 'Admin',
      };
}
