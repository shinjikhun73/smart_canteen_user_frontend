import '../../config/api_config.dart';
import '../../dtos/auth_dto.dart';
import 'auth_repository.dart';

class AuthRepositoryNestjs implements AuthRepository {
  // TODO: inject an HTTP client (e.g. Dio) here
  // final Dio _dio;

  @override
  Future<AuthTokenDto> login({required String email, required String password}) {
    throw UnimplementedError('Connect ${ApiConfig.login} endpoint');
  }

  @override
  Future<AuthTokenDto> register({
    required String email,
    required String password,
    required String fullName,
  }) {
    throw UnimplementedError('Connect ${ApiConfig.register} endpoint');
  }

  @override
  Future<AuthTokenDto> refreshToken(String refreshToken) {
    throw UnimplementedError('Connect ${ApiConfig.refreshToken} endpoint');
  }

  @override
  Future<UserProfileDto> getProfile() {
    throw UnimplementedError('Connect /auth/profile endpoint');
  }

  @override
  Future<void> logout() {
    throw UnimplementedError('Connect ${ApiConfig.logout} endpoint');
  }
}
