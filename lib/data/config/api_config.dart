import 'package:flutter/foundation.dart'
    show kDebugMode, kIsWeb, defaultTargetPlatform, TargetPlatform;

class ApiConfig {
  ApiConfig._();

  /// An explicit override, e.g. for a physical device on your LAN:
  /// `--dart-define=API_BASE_URL=http://<your-mac-lan-ip>:3000/api/v1`.
  /// When set, it always wins.
  static const String _override = String.fromEnvironment('API_BASE_URL');

  static const String _prodUrl = 'https://api.smartcanteen.cadt.edu.kh/v1';

  /// Base URL resolution:
  /// - `--dart-define=API_BASE_URL=...` always wins.
  /// - Release builds hit production.
  /// - Debug builds hit the local Docker backend, but the host differs by
  ///   platform: the Android *emulator* reaches the host machine at the
  ///   special alias `10.0.2.2`, while iOS simulator / desktop / web use
  ///   `localhost`. (A physical device can't use either — pass the override.)
  static String get baseUrl {
    if (_override.isNotEmpty) return _override;
    if (!kDebugMode) return _prodUrl;
    return 'http://$_debugHost:3000/api/v1';
  }

  static String get _debugHost {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      // Only the Android emulator maps the host to 10.0.2.2. A real Android
      // device would need the LAN IP via --dart-define instead.
      return '10.0.2.2';
    }
    return 'localhost';
  }

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String googleLogin = '/auth/google';
  static const String profile = '/users/me';

  /// `PATCH /users/:id/profile` — update the signed-in user's own profile
  /// (first/last name, phone, avatar, school). See backend `UsersController.updateProfile`.
  static String userProfile(String id) => '/users/$id/profile';

  /// `GET /schools` — list of selectable schools for onboarding.
  static const String schools = '/schools';

  // Menu
  static const String weeklyMenu = '/menu/weekly';
  static const String menuBySession = '/menu/session';

  // Coupon / orders
  static const String couponPlans = '/coupons/plans';
  static const String purchaseCoupon = '/coupons/purchase';
  static const String orderHistory = '/coupons/history';

  // Wallet
  static const String walletBalance = '/wallet/balance';
  static const String topUp = '/wallet/topup';
  static const String transactions = '/wallet/transactions';

  // Notifications
  static const String notifications = '/notifications';
  static const String markRead = '/notifications/read';
}
