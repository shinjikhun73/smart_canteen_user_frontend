import 'package:flutter/material.dart';

import 'ui/screens/home/home_screen.dart';
import 'ui/screens/login/sign_in_screen.dart';
import 'ui/screens/signup/sign_up_screen.dart';
import 'ui/screens/splash/splash_screen.dart';
import 'ui/screens/menu/menu_screen.dart';
import 'ui/screens/order/order_summary_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const SmartCanteenApp());
}

class SmartCanteenApp extends StatelessWidget {
  const SmartCanteenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      },
    );
  }
}
