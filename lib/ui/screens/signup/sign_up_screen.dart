import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../widgets/smart_canteen_widgets.dart';
import '../home/home_screen.dart';
import '../login/sign_in_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  static const routeName = '/sign-up';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 32,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Sign Up',
                          style: TextStyle(color: Colors.black45, fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const _AuthHero(
                        title: 'Create Account',
                        subtitle:
                            'Create your account now and start\nyour meal at once',
                      ),
                      const SizedBox(height: 18),
                      SmartCanteenAuthSwitch(
                        isLoginSelected: false,
                        onLoginTap: () {
                          Navigator.pushReplacementNamed(
                            context,
                            SignInScreen.routeName,
                          );
                        },
                        onSignUpTap: () {},
                      ),
                      const SizedBox(height: 20),
                      const SmartCanteenTextField(
                        label: 'Email',
                        hintText: 'Enter your email',
                        prefixIcon: Icon(
                          Icons.mail_outline,
                          color: AppTheme.green,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const SmartCanteenTextField(
                        label: 'Password',
                        hintText: 'Enter your password',
                        obscureText: true,
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: AppTheme.green,
                        ),
                        suffixIcon: Icon(
                          Icons.visibility_outlined,
                          color: AppTheme.mutedText,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const SmartCanteenTextField(
                        label: 'Confirm Password',
                        hintText: 'Enter your password again',
                        obscureText: true,
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: AppTheme.green,
                        ),
                        suffixIcon: Icon(
                          Icons.visibility_outlined,
                          color: AppTheme.mutedText,
                        ),
                      ),
                      const SizedBox(height: 18),
                      SmartCanteenButton(
                        label: 'Sign Up',
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            HomeScreen.routeName,
                          );
                        },
                      ),
                      const SizedBox(height: 18),
                      const SmartCanteenDividerText(label: 'OR CONTINUE WITH'),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          SmartCanteenSocialButton(
                            label: 'Google',
                            icon: _socialIcon(
                              Icons.g_mobiledata,
                              color: const Color(0xFF4285F4),
                            ),
                          ),
                          const SizedBox(width: 12),
                          SmartCanteenSocialButton(
                            label: 'Facebook',
                            icon: _socialIcon(
                              Icons.facebook,
                              color: const Color(0xFF1877F2),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AuthHero extends StatelessWidget {
  const _AuthHero({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context).width.clamp(260.0, 360.0) * 0.72;

    return Container(
      height: 178,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF7CCC8A), AppTheme.green],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -18,
            top: -18,
            child: Opacity(opacity: 0.18, child: CanteenLogo(size: size)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.2,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _socialIcon(IconData iconData, {required Color color}) {
  return Container(
    width: 24,
    height: 24,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
      border: Border.all(color: AppTheme.border),
    ),
    child: Icon(iconData, color: color, size: 18),
  );
}
