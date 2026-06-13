import 'package:flutter/material.dart';

class AnimationUtils {
  /// Fade + slide-up transition for page routes.
  static Route<T> fadeSlideUp<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (_, animation, _) => page,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (_, animation, _, child) {
        final fade = CurvedAnimation(parent: animation, curve: Curves.easeOut);
        final slide = Tween<Offset>(
          begin: const Offset(0, 0.06),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

        return FadeTransition(
          opacity: fade,
          child: SlideTransition(position: slide, child: child),
        );
      },
    );
  }

  /// Elastic scale-in for hero elements (e.g. logo splash).
  static Animation<double> elasticScale(AnimationController controller) {
    return Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.elasticOut),
    );
  }

  /// Standard card appear duration used across the app.
  static const Duration cardAppear = Duration(milliseconds: 200);

  /// Standard page transition duration.
  static const Duration pageTransition = Duration(milliseconds: 300);
}
