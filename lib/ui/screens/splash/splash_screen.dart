import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../widgets/smart_canteen_widgets.dart';
import '../login/sign_in_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const routeName = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;

  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;

  late final Animation<double> _subtitleFade;
  late final Animation<Offset> _subtitleSlide;

  late final Animation<double> _buttonFade;
  late final Animation<Offset> _buttonSlide;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Logo: elastic scale-in with a quick fade
    _logoScale = Tween<double>(begin: 0.25, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.0, 0.62, curve: Curves.elasticOut),
      ),
    );
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.0, 0.22, curve: Curves.easeIn),
      ),
    );

    // Title: fade + slide up
    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.40, 0.65, curve: Curves.easeIn),
      ),
    );
    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.55), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _ctrl,
            curve: const Interval(0.40, 0.65, curve: Curves.easeOut),
          ),
        );

    // Subtitle: fade + slide up (slightly delayed)
    _subtitleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.55, 0.78, curve: Curves.easeIn),
      ),
    );
    _subtitleSlide =
        Tween<Offset>(begin: const Offset(0, 0.55), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _ctrl,
            curve: const Interval(0.55, 0.78, curve: Curves.easeOut),
          ),
        );

    // Button: fade + slight slide up (last to appear)
    _buttonFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.72, 1.0, curve: Curves.easeIn),
      ),
    );
    _buttonSlide = Tween<Offset>(begin: const Offset(0, 0.35), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _ctrl,
            curve: const Interval(0.72, 1.0, curve: Curves.easeOut),
          ),
        );

    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _navigateToSignIn() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 550),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (_, _, _) => const SignInScreen(),
        transitionsBuilder: (_, animation, _, child) {
          final fade = CurvedAnimation(parent: animation, curve: Curves.easeIn);
          final slide =
              Tween<Offset>(
                begin: const Offset(0, 0.06),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );
          return FadeTransition(
            opacity: fade,
            child: SlideTransition(position: slide, child: child),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final logoSize = constraints.maxWidth.clamp(240.0, 320.0) * 0.72;

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FadeTransition(
                            opacity: _logoFade,
                            child: ScaleTransition(
                              scale: _logoScale,
                              child: CanteenLogo(size: logoSize),
                            ),
                          ),
                          const SizedBox(height: 28),
                          FadeTransition(
                            opacity: _titleFade,
                            child: SlideTransition(
                              position: _titleSlide,
                              child: const Text(
                                'Smart Canteen',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.green,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          FadeTransition(
                            opacity: _subtitleFade,
                            child: SlideTransition(
                              position: _subtitleSlide,
                              child: const Text(
                                'Scan Eat Enjoy — The Smart Way',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.mutedText,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  FadeTransition(
                    opacity: _buttonFade,
                    child: SlideTransition(
                      position: _buttonSlide,
                      child: SafeArea(
                        top: false,
                        child: SizedBox(
                          width: 180, // fixed smaller width
                          child: SmartCanteenButton(
                            label: 'Get Started',
                            onPressed: _navigateToSignIn,
                            height: 44, // smaller height
                            radius:
                                30, // optional: adjust corner radius for balance
                            width: 180, // fixed smaller width
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
