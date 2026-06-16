import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/repositories/auth/auth_repository.dart';
import 'data/repositories/coupon/coupon_repository.dart';
import 'data/repositories/menu/menu_repository.dart';
import 'data/repositories/wallet/wallet_repository.dart';
import 'models/cart_model.dart';
import 'theme/app_theme.dart';
import 'ui/screens/alerts/notification_screen.dart';
import 'ui/screens/alerts/view_model/notification_view_model.dart';
import 'ui/screens/coupon_purchase/order_summary_screen.dart';
import 'ui/screens/coupon_purchase/view_model/purchase_view_model.dart';
import 'ui/screens/digital_wallet/history_screen.dart';
import 'ui/screens/digital_wallet/qr_screen.dart';
import 'ui/screens/digital_wallet/view_model/wallet_view_model.dart';
import 'ui/screens/shell/app_shell.dart';
import 'ui/screens/login/sign_in_screen.dart';
import 'ui/screens/login/sign_up_screen.dart';
import 'ui/screens/login/view_model/auth_view_model.dart';
import 'ui/screens/menu_browsing/menu_screen.dart';
import 'ui/screens/menu_browsing/view_model/menu_view_model.dart';
import 'ui/screens/profile/profile_screen.dart';
import 'ui/screens/splash/splash_screen.dart';
import 'ui/states/active_coupon_state.dart';
import 'ui/states/app_settings_state.dart';
import 'ui/states/balance_state.dart';
import 'ui/states/order_history_state.dart';

class SmartCanteenApp extends StatefulWidget {
  const SmartCanteenApp({
    super.key,
    required this.authRepository,
    required this.menuRepository,
    required this.couponRepository,
    required this.walletRepository,
  });

  final AuthRepository authRepository;
  final MenuRepository menuRepository;
  final CouponRepository couponRepository;
  final WalletRepository walletRepository;

  @override
  State<SmartCanteenApp> createState() => _SmartCanteenAppState();
}

class _SmartCanteenAppState extends State<SmartCanteenApp> {
  final _cart = CartModel();

  @override
  void dispose() {
    _cart.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Repositories
        Provider<AuthRepository>.value(value: widget.authRepository),
        Provider<MenuRepository>.value(value: widget.menuRepository),
        Provider<CouponRepository>.value(value: widget.couponRepository),
        Provider<WalletRepository>.value(value: widget.walletRepository),

        // Global states
        ChangeNotifierProvider(create: (_) => AppSettingsState()),
        ChangeNotifierProvider(create: (_) => OrderHistoryState()),
        ChangeNotifierProvider(
            create: (_) => BalanceState(widget.walletRepository)),
        ChangeNotifierProvider(
            create: (_) => ActiveCouponState(widget.couponRepository)),

        // Screen view models
        ChangeNotifierProvider(
            create: (_) => AuthViewModel(widget.authRepository)),
        ChangeNotifierProvider(
            create: (_) => MenuViewModel(widget.menuRepository)),
        ChangeNotifierProvider(
            create: (_) => PurchaseViewModel(widget.couponRepository)),
        ChangeNotifierProvider(
          create: (_) =>
              WalletViewModel(widget.walletRepository, widget.couponRepository),
        ),
        ChangeNotifierProvider(create: (_) => NotificationViewModel()),
      ],
      child: CartProvider(
        cart: _cart,
        child: Consumer<AppSettingsState>(
          builder: (_, settings, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Smart Canteen',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode:
                settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            initialRoute: SplashScreen.routeName,
            routes: {
              SplashScreen.routeName: (_) => const SplashScreen(),
              SignInScreen.routeName: (_) => const SignInScreen(),
              SignUpScreen.routeName: (_) => const SignUpScreen(),
              AppShell.routeName: (_) => const AppShell(),
              MenuScreen.routeName: (_) => const MenuScreen(),
              OrderSummaryScreen.routeName: (_) => const OrderSummaryScreen(),
              QrScreen.routeName: (_) => const QrScreen(),
              HistoryScreen.routeName: (_) => const HistoryScreen(),
              ProfileScreen.routeName: (_) => const ProfileScreen(),
              NotificationScreen.routeName: (_) => const NotificationScreen(),
            },
          ),
        ),
      ),
    );
  }
}
