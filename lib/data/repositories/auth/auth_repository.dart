import '../../dtos/auth_dto.dart';

abstract class AuthRepository {
  Future<AuthTokenDto> login({required String email, required String password});
  Future<AuthTokenDto> register({required String email, required String password, required String fullName});
  Future<AuthTokenDto> refreshToken(String refreshToken);
  Future<UserProfileDto> getProfile();
  Future<void> logout();
}
