import 'package:flutter/material.dart';

import '../login/sign_in_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  static const routeName = '/sign-up';

  @override
  Widget build(BuildContext context) {
    return const SignInScreen(initialIsLogin: false);
  }
}
