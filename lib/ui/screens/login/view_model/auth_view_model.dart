import 'package:flutter/foundation.dart';

import '../../../../data/repositories/auth/auth_repository.dart';
import '../../../../model/user/user.dart';
import '../../../utils/async_value.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  AsyncValue<User> _loginState = const AsyncLoading();
  AsyncValue<User> _registerState = const AsyncLoading();

  AuthViewModel(this._authRepository);

  AsyncValue<User> get loginState => _loginState;
  AsyncValue<User> get registerState => _registerState;

  Future<void> login({required String email, required String password}) async {
    _loginState = const AsyncLoading();
    notifyListeners();

    try {
      await _authRepository.login(email: email, password: password);
      final profileDto = await _authRepository.getProfile();
      _loginState = AsyncData(User.fromDto(profileDto));
    } catch (e, s) {
      _loginState = AsyncError(e, s);
    }

    notifyListeners();
  }

  Future<void> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    _registerState = const AsyncLoading();
    notifyListeners();

    try {
      await _authRepository.register(
        email: email,
        password: password,
        fullName: fullName,
      );
      final profileDto = await _authRepository.getProfile();
      _registerState = AsyncData(User.fromDto(profileDto));
    } catch (e, s) {
      _registerState = AsyncError(e, s);
    }

    notifyListeners();
  }

  /// Signs in with Google. Uses the same [loginState] as [login] since,
  /// from the UI's perspective, it's just another way to end up logged in.
  Future<void> loginWithGoogle() async {
    _loginState = const AsyncLoading();
    notifyListeners();

    try {
      await _authRepository.loginWithGoogle();
      final profileDto = await _authRepository.getProfile();
      _loginState = AsyncData(User.fromDto(profileDto));
    } catch (e, s) {
      _loginState = AsyncError(e, s);
    }

    notifyListeners();
  }

  Future<void> logout() async {
    await _authRepository.logout();
    _loginState = const AsyncLoading();
    _registerState = const AsyncLoading();
    notifyListeners();
  }

  void resetStates() {
    _loginState = const AsyncLoading();
    _registerState = const AsyncLoading();
    notifyListeners();
  }
}
