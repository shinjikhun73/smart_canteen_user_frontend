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

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
