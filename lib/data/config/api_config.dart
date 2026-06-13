class ApiConfig {
  ApiConfig._();

  static const String baseUrl = 'https://api.smartcanteen.cadt.edu.kh/v1';

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';

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
