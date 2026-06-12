import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../widgets/smart_canteen_widgets.dart';
import '../home/home_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key, this.initialIsLogin = true});

  static const routeName = '/sign-in';
  final bool initialIsLogin;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late bool _isLogin;
  bool _rememberMe = true;

  @override
  void initState() {
    super.initState();
    _isLogin = widget.initialIsLogin;
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature — coming soon'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppTheme.green,
      ),
    );
  }

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
                      const SizedBox(height: 12),
                      // Hero banner — text changes instantly with the tab
                      _AuthHero(
                        title: _isLogin ? 'Welcome Back' : 'Create Account',
                        subtitle: _isLogin
                            ? 'fresh foods are waiting\nto be in your mouth'
                            : 'Create your account now and start\nyour meal at once',
                      ),
                      const SizedBox(height: 18),
                      // Tab switch
                      SmartCanteenAuthSwitch(
                        isLoginSelected: _isLogin,
                        onLoginTap: () => setState(() => _isLogin = true),
                        onSignUpTap: () => setState(() => _isLogin = false),
                      ),
                      const SizedBox(height: 20),
                      // Form content — slides left/right when the tab changes
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 340),
                        transitionBuilder: (child, animation) {
                          // Login form lives on the left, sign-up on the right.
                          // Each form slides in from its side and slides out to its side
                          // using the reversed animation for the outgoing child.
                          final isLoginForm =
                              child.key == const ValueKey('login');
                          final offset =
                              Offset(isLoginForm ? -1.0 : 1.0, 0.0);
                          return ClipRect(
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: offset,
                                end: Offset.zero,
                              ).animate(CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeOutCubic,
                              )),
                              child: FadeTransition(
                                opacity: Tween<double>(begin: 0.0, end: 1.0)
                                    .animate(CurvedAnimation(
                                  parent: animation,
                                  curve: const Interval(0.0, 0.55),
                                )),
                                child: child,
                              ),
                            ),
                          );
                        },
                        // layoutBuilder keeps both children top-aligned during transition
                        layoutBuilder: (currentChild, previousChildren) {
                          return Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              ...previousChildren,
                              ?currentChild,
                            ],
                          );
                        },
                        child: _isLogin
                            ? _LoginForm(
                                key: const ValueKey('login'),
                                rememberMe: _rememberMe,
                                onRememberMeChanged: (v) => setState(
                                    () => _rememberMe = v ?? false),
                                onLogin: () =>
                                    Navigator.pushReplacementNamed(
                                        context, HomeScreen.routeName),
                                onComingSoon: _showComingSoon,
                              )
                            : _SignUpForm(
                                key: const ValueKey('signup'),
                                onSignUp: () =>
                                    Navigator.pushReplacementNamed(
                                        context, HomeScreen.routeName),
                                onComingSoon: _showComingSoon,
                              ),
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

// ── Login form ──────────────────────────────────────────────────────────────

class _LoginForm extends StatelessWidget {
  const _LoginForm({
    super.key,
    required this.rememberMe,
    required this.onRememberMeChanged,
    required this.onLogin,
    required this.onComingSoon,
  });

  final bool rememberMe;
  final ValueChanged<bool?> onRememberMeChanged;
  final VoidCallback onLogin;
  final void Function(String) onComingSoon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SmartCanteenTextField(
          label: 'Email',
          hintText: 'Enter your email',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icon(Icons.mail_outline, color: AppTheme.green),
        ),
        const SizedBox(height: 16),
        const SmartCanteenTextField(
          label: 'Password',
          hintText: 'Enter your password',
          obscureText: true,
          prefixIcon: Icon(Icons.lock_outline, color: AppTheme.green),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Transform.scale(
              scale: 0.95,
              child: Checkbox(
                value: rememberMe,
                activeColor: AppTheme.green,
                onChanged: onRememberMeChanged,
              ),
            ),
            const Text(
              'Remember me',
              style: TextStyle(color: AppTheme.mutedText, fontSize: 13),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => onComingSoon('Password reset'),
              child: const Text(
                'Forgot Password?',
                style: TextStyle(
                  color: AppTheme.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        SmartCanteenButton(label: 'Log In', onPressed: onLogin),
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
              onTap: () => onComingSoon('Google Sign-In'),
            ),
            const SizedBox(width: 12),
            SmartCanteenSocialButton(
              label: 'Facebook',
              icon: _socialIcon(
                Icons.facebook,
                color: const Color(0xFF1877F2),
              ),
              onTap: () => onComingSoon('Facebook Sign-In'),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Sign-up form ────────────────────────────────────────────────────────────

class _SignUpForm extends StatelessWidget {
  const _SignUpForm({
    super.key,
    required this.onSignUp,
    required this.onComingSoon,
  });

  final VoidCallback onSignUp;
  final void Function(String) onComingSoon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SmartCanteenTextField(
          label: 'Email',
          hintText: 'Enter your email',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icon(Icons.mail_outline, color: AppTheme.green),
        ),
        const SizedBox(height: 16),
        const SmartCanteenTextField(
          label: 'Password',
          hintText: 'Enter your password',
          obscureText: true,
          prefixIcon: Icon(Icons.lock_outline, color: AppTheme.green),
        ),
        const SizedBox(height: 16),
        const SmartCanteenTextField(
          label: 'Confirm Password',
          hintText: 'Re-enter your password',
          obscureText: true,
          prefixIcon: Icon(Icons.lock_outline, color: AppTheme.green),
        ),
        const SizedBox(height: 18),
        SmartCanteenButton(label: 'Sign Up', onPressed: onSignUp),
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
              onTap: () => onComingSoon('Google Sign-Up'),
            ),
            const SizedBox(width: 12),
            SmartCanteenSocialButton(
              label: 'Facebook',
              icon: _socialIcon(
                Icons.facebook,
                color: const Color(0xFF1877F2),
              ),
              onTap: () => onComingSoon('Facebook Sign-Up'),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Shared hero banner ──────────────────────────────────────────────────────

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
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Text(
                    title,
                    key: ValueKey(title),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Text(
                    subtitle,
                    key: ValueKey(subtitle),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      height: 1.2,
                    ),
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
