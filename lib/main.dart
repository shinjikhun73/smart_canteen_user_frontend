import 'package:flutter/material.dart';

import 'models/cart_model.dart';
import 'theme/app_theme.dart';
import 'ui/screens/history/history_screen.dart';
import 'ui/screens/home/home_screen.dart';
import 'ui/screens/login/sign_in_screen.dart';
import 'ui/screens/menu/menu_screen.dart';
import 'ui/screens/order/order_summary_screen.dart';
import 'ui/screens/profile/profile_screen.dart';
import 'ui/screens/qr/qr_screen.dart';
import 'ui/screens/signup/sign_up_screen.dart';
import 'ui/screens/splash/splash_screen.dart';

void main() {
  runApp(const SmartCanteenApp());
}

class SmartCanteenApp extends StatefulWidget {
  const SmartCanteenApp({super.key});

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
    return CartProvider(
      cart: _cart,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Smart Canteen',
        theme: AppTheme.lightTheme,
        initialRoute: SplashScreen.routeName,
        routes: {
          SplashScreen.routeName: (_) => const SplashScreen(),
          SignInScreen.routeName: (_) => const SignInScreen(),
          SignUpScreen.routeName: (_) => const SignUpScreen(),
          HomeScreen.routeName: (_) => const HomeScreen(),
          MenuScreen.routeName: (_) => const MenuScreen(),
          OrderSummaryScreen.routeName: (_) => const OrderSummaryScreen(),
          QrScreen.routeName: (_) => const QrScreen(),
          HistoryScreen.routeName: (_) => const HistoryScreen(),
          ProfileScreen.routeName: (_) => const ProfileScreen(),
        },
      ),
    );
  }
}
