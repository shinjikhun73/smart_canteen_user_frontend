import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class SmartCanteenSocialButton extends StatefulWidget {
  const SmartCanteenSocialButton({
    super.key,
    required this.label,
    required this.icon,
    this.onTap,
  });

  final String label;
  final Widget icon;
  final VoidCallback? onTap;

  @override
  State<SmartCanteenSocialButton> createState() =>
      _SmartCanteenSocialButtonState();
}

class _SmartCanteenSocialButtonState extends State<SmartCanteenSocialButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _borderColorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _borderColorAnimation = ColorTween(
      begin: AppTheme.border,
      end: AppTheme.green.withValues(alpha: 0.3),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handlePress() {
    _controller.forward().then((_) {
      _controller.reverse();
    });
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: GestureDetector(
          onTap: _handlePress,
          child: AnimatedBuilder(
            animation: _borderColorAnimation,
            builder: (context, child) {
              return Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: _borderColorAnimation.value ?? AppTheme.border,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.green.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget.icon,
                    const SizedBox(width: 10),
                    Text(
                      widget.label,
                      style: const TextStyle(
                        color: AppTheme.green,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
