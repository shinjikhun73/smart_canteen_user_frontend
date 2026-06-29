import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../widgets/smart_canteen_widgets.dart';
import '../home/home_screen.dart';

/// Brand gradient used for the primary action buttons (#4CAF50 → #81C784).
const _primaryGradient = LinearGradient(
  colors: [AppTheme.green, Color(0xFF81C784)],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

const _googleBlue = Color(0xFF4285F4);
const _facebookBlue = Color(0xFF1877F2);

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
      body: Container(
        // Soft gradient backdrop — light green fading into white.
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.greenSurface, Color(0xFFF7F8FA)],
            begin: Alignment.topCenter,
            end: Alignment.center,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                // Header — food badge + title + tagline
                _AuthHeader(isLogin: _isLogin),
                const SizedBox(height: 28),
                // Floating form card with a soft shadow for depth
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.green.withValues(alpha: 0.08),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 28,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Tab switch
                      SmartCanteenAuthSwitch(
                        isLoginSelected: _isLogin,
                        onLoginTap: () => setState(() => _isLogin = true),
                        onSignUpTap: () => setState(() => _isLogin = false),
                      ),
                      const SizedBox(height: 28),
                      // Form content — fade + slide transition
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 450),
                        switchInCurve: Curves.easeInOut,
                        switchOutCurve: Curves.easeInOut,
                        transitionBuilder: (child, animation) {
                          final isLoginForm =
                              child.key == const ValueKey('login');
                          final slideOffset = Offset(
                            isLoginForm ? -0.25 : 0.25,
                            0.0,
                          );

                          return ClipRect(
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: slideOffset,
                                end: Offset.zero,
                              ).animate(animation),
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            ),
                          );
                        },
                        layoutBuilder: (currentChild, previousChildren) {
                          return Stack(
                            alignment: Alignment.topCenter,
                            children: [...previousChildren, ?currentChild],
                          );
                        },
                        child: _isLogin
                            ? _LoginForm(
                                key: const ValueKey('login'),
                                rememberMe: _rememberMe,
                                onRememberMeChanged: (v) =>
                                    setState(() => _rememberMe = v ?? false),
                                onLogin: () => Navigator.pushReplacementNamed(
                                  context,
                                  HomeScreen.routeName,
                                ),
                                onComingSoon: _showComingSoon,
                              )
                            : _SignUpForm(
                                key: const ValueKey('signup'),
                                onSignUp: () => Navigator.pushReplacementNamed(
                                  context,
                                  HomeScreen.routeName,
                                ),
                                onComingSoon: _showComingSoon,
                              ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Header (badge + title + tagline) ─────────────────────────────────────────

class _AuthHeader extends StatelessWidget {
  const _AuthHeader({required this.isLogin});

  final bool isLogin;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Minimal food-themed badge
        Container(
          width: 84,
          height: 84,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: _primaryGradient,
            boxShadow: [
              BoxShadow(
                color: AppTheme.green.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.restaurant_menu,
            color: Colors.white,
            size: 40,
          ),
        ),
        const SizedBox(height: 20),
        // Title — large, bold, animates with the active tab
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -0.15),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              ),
              child: child,
            ),
          ),
          child: Text(
            isLogin ? 'Welcome Back' : 'Create Account',
            key: ValueKey(isLogin),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppTheme.greenDark,
              fontSize: 30,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Tagline — lighter weight
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (child, animation) =>
              FadeTransition(opacity: animation, child: child),
          child: Text(
            isLogin
                ? 'Fresh meals are waiting for you'
                : 'Join us and start your meal journey',
            key: ValueKey(isLogin),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.text.withValues(alpha: 0.5),
              fontSize: 14,
              height: 1.4,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ],
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
          label: 'Email Address',
          hintText: 'Enter your email',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icon(Icons.mail_outline, color: AppTheme.green, size: 20),
        ),
        const SizedBox(height: 18),
        const SmartCanteenTextField(
          label: 'Password',
          hintText: 'Enter your password',
          obscureText: true,
          prefixIcon: Icon(Icons.lock_outline, color: AppTheme.green, size: 20),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Checkbox(
              value: rememberMe,
              activeColor: AppTheme.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              side: const BorderSide(color: Color(0xFFE8E8E8), width: 1.5),
              onChanged: onRememberMeChanged,
            ),
            const Text(
              'Remember me',
              style: TextStyle(
                color: AppTheme.mutedText,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            _ForgotPasswordButton(onTap: () => onComingSoon('Password reset')),
          ],
        ),
        const SizedBox(height: 24),
        SmartCanteenButton(
          label: 'Log In',
          onPressed: onLogin,
          gradient: _primaryGradient,
        ),
        const SizedBox(height: 24),
        const SmartCanteenDividerText(label: 'OR CONTINUE WITH'),
        const SizedBox(height: 20),
        _SocialRow(suffix: 'Sign-In', onComingSoon: onComingSoon),
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
          label: 'Email Address',
          hintText: 'Enter your email',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icon(Icons.mail_outline, color: AppTheme.green, size: 20),
        ),
        const SizedBox(height: 18),
        const SmartCanteenTextField(
          label: 'Password',
          hintText: 'Enter your password',
          obscureText: true,
          prefixIcon: Icon(Icons.lock_outline, color: AppTheme.green, size: 20),
        ),
        const SizedBox(height: 18),
        const SmartCanteenTextField(
          label: 'Confirm Password',
          hintText: 'Re-enter your password',
          obscureText: true,
          prefixIcon: Icon(Icons.lock_outline, color: AppTheme.green, size: 20),
        ),
        const SizedBox(height: 24),
        SmartCanteenButton(
          label: 'Sign Up',
          onPressed: onSignUp,
          gradient: _primaryGradient,
        ),
        const SizedBox(height: 24),
        const SmartCanteenDividerText(label: 'OR CONTINUE WITH'),
        const SizedBox(height: 20),
        _SocialRow(suffix: 'Sign-Up', onComingSoon: onComingSoon),
      ],
    );
  }
}

// ── Shared social button row ─────────────────────────────────────────────────

class _SocialRow extends StatelessWidget {
  const _SocialRow({required this.suffix, required this.onComingSoon});

  final String suffix;
  final void Function(String) onComingSoon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SmartCanteenSocialButton(
          label: 'Google',
          brandColor: _googleBlue,
          icon: _socialIcon(Icons.g_mobiledata, color: _googleBlue),
          onTap: () => onComingSoon('Google $suffix'),
        ),
        const SizedBox(width: 14),
        SmartCanteenSocialButton(
          label: 'Facebook',
          brandColor: _facebookBlue,
          icon: _socialIcon(Icons.facebook, color: _facebookBlue),
          onTap: () => onComingSoon('Facebook $suffix'),
        ),
      ],
    );
  }
}

// ── Forgot Password Button with Micro-interaction ──────────────────────────

class _ForgotPasswordButton extends StatefulWidget {
  const _ForgotPasswordButton({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_ForgotPasswordButton> createState() => _ForgotPasswordButtonState();
}

class _ForgotPasswordButtonState extends State<_ForgotPasswordButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _colorAnimation = ColorTween(
      begin: AppTheme.green,
      end: AppTheme.green.withValues(alpha: 0.7),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHoverOrTap() {
    if (_controller.isCompleted) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: GestureDetector(
        onTap: _onHoverOrTap,
        child: AnimatedBuilder(
          animation: _colorAnimation,
          builder: (context, child) {
            return Text(
              'Forgot Password?',
              style: TextStyle(
                color: _colorAnimation.value,
                fontWeight: FontWeight.w600,
                fontSize: 13,
                letterSpacing: 0.2,
              ),
            );
          },
        ),
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
