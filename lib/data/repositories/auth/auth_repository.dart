import '../../dtos/auth_dto.dart';

abstract class AuthRepository {
  Future<AuthTokenDto> login({required String email, required String password});
  Future<AuthTokenDto> register({required String email, required String password, required String fullName});

  /// Runs the native Google sign-in flow (via google_sign_in) and exchanges
  /// the resulting ID token with the backend for our own JWT pair.
  Future<AuthTokenDto> loginWithGoogle();

  Future<AuthTokenDto> refreshToken(String refreshToken);
  Future<UserProfileDto> getProfile();
  Future<void> logout();
}
