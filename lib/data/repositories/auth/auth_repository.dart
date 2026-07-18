import '../../dtos/auth_dto.dart';

abstract class AuthRepository {
  Future<AuthTokenDto> login({required String email, required String password});
  Future<AuthTokenDto> register({required String email, required String password, required String fullName});

  /// Runs the native Google sign-in flow (via google_sign_in) and exchanges
  /// the resulting ID token with the backend for our own JWT pair.
  Future<AuthTokenDto> loginWithGoogle();

  Future<AuthTokenDto> refreshToken(String refreshToken);
  Future<UserProfileDto> getProfile();

  /// Updates the signed-in user's own profile and returns the fresh record.
  /// Only non-null fields are sent, so callers can patch a subset.
  Future<UserProfileDto> updateProfile({
    required String userId,
    String? firstName,
    String? lastName,
    String? phone,
    String? schoolId,
  });

  /// Updates the signed-in user's notification preferences and returns the
  /// fresh set. Only non-null flags are sent, so callers can patch a subset.
  Future<NotificationPreferencesDto> updateNotificationPreferences({
    required String userId,
    bool? orderUpdates,
    bool? promotions,
    bool? systemAlerts,
  });

  /// Lists the schools a user can pick from during onboarding.
  Future<List<SchoolDto>> getSchools();

  Future<void> logout();
}
