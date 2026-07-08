import '../../dtos/auth_dto.dart';
import 'auth_repository.dart';

class AuthRepositoryMock implements AuthRepository {
  @override
  Future<AuthTokenDto> login({required String email, required String password}) async {
    await Future.delayed(const Duration(seconds: 1));
    return const AuthTokenDto(
      accessToken: 'mock-access-token',
      refreshToken: 'mock-refresh-token',
      expiresIn: 3600,
    );
  }

  @override
  Future<AuthTokenDto> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return const AuthTokenDto(
      accessToken: 'mock-access-token',
      refreshToken: 'mock-refresh-token',
      expiresIn: 3600,
    );
  }

  @override
  Future<AuthTokenDto> loginWithGoogle() async {
    await Future.delayed(const Duration(seconds: 1));
    return const AuthTokenDto(
      accessToken: 'mock-google-access-token',
      refreshToken: 'mock-refresh-token',
      expiresIn: 3600,
    );
  }

  @override
  Future<AuthTokenDto> refreshToken(String refreshToken) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const AuthTokenDto(
      accessToken: 'mock-access-token-refreshed',
      refreshToken: 'mock-refresh-token',
      expiresIn: 3600,
    );
  }

  @override
  Future<UserProfileDto> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const UserProfileDto(
      id: 'mock-user-001',
      email: 'john.doe@cadt.edu.kh',
      firstName: 'John',
      lastName: 'Doe',
      status: 'active',
      role: RoleDto(id: 'mock-role-student', name: 'student'),
      school: SchoolDto(id: 'mock-school-cadt', name: 'CADT'),
    );
  }

  static const _mockSchools = [
    SchoolDto(id: 'mock-school-cadt', name: 'CADT'),
    SchoolDto(id: 'mock-school-rupp', name: 'RUPP'),
    SchoolDto(id: 'mock-school-itc', name: 'ITC'),
  ];

  @override
  Future<UserProfileDto> updateProfile({
    required String userId,
    String? firstName,
    String? lastName,
    String? phone,
    String? schoolId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final school = _mockSchools.firstWhere(
      (s) => s.id == schoolId,
      orElse: () => _mockSchools.first,
    );
    return UserProfileDto(
      id: userId,
      email: 'john.doe@cadt.edu.kh',
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      status: 'active',
      role: const RoleDto(id: 'mock-role-student', name: 'student'),
      school: school,
    );
  }

  @override
  Future<List<SchoolDto>> getSchools() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockSchools;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
