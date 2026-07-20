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

  /// `PATCH /users/:id/notification-preferences` — update the signed-in user's
  /// push-notification preferences. See backend
  /// `UsersController.updateNotificationPreferences`.
  static String userNotificationPreferences(String id) =>
      '/users/$id/notification-preferences';

  /// `GET /schools` — list of selectable schools for onboarding.
  static const String schools = '/schools';

  // Menu
  /// `GET /menu-items` — menu items, filterable by `school_id`,
  /// `availability_status`, paginated (`limit` max 100).
  static const String menuItems = '/menu-items';

  // Orders
  /// `POST /orders` — place an order (auto-mints a QR coupon per item);
  /// `GET /orders/my` — the signed-in user's orders.
  static const String orders = '/orders';
  static const String ordersMy = '/orders/my';

  // Coupons
  /// `GET /coupons?user_id=&status=` — the user's meal-ticket coupons.
  static const String coupons = '/coupons';

  // Wallet
  /// `GET /wallet/my` — all wallets for the signed-in user (one per school).
  static const String walletMy = '/wallet/my';

  /// `POST /wallet/:id/top-up` — add funds to a wallet.
  static String walletTopUp(String walletId) => '/wallet/$walletId/top-up';

  /// `POST /wallet/:id/pay` — deduct a payment from a wallet.
  static String walletPay(String walletId) => '/wallet/$walletId/pay';

  /// `GET /wallet/:id/transactions` — transaction history for a wallet.
  static String walletTransactions(String walletId) =>
      '/wallet/$walletId/transactions';

  // Notifications — backed by the announcements broadcast feed.
  /// `GET /announcements?status=&page=&limit=` — published announcements shown
  /// in the app's Alerts screen. See backend `AnnouncementsController.findAll`.
  static const String announcements = '/announcements';
}
