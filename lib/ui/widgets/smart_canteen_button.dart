import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class SmartCanteenButton extends StatefulWidget {
  const SmartCanteenButton({
    super.key,
    required this.label,
    this.onPressed,
    this.fillColor = AppTheme.green,
    this.textColor = Colors.white,
    this.height = 52,
    this.radius = 30,
    this.leading,
    this.width = double.infinity,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color fillColor;
  final Color textColor;
  final double height;
  final double radius;
  final Widget? leading;
  final double width;

  @override
  State<SmartCanteenButton> createState() => _SmartCanteenButtonState();
}

class _SmartCanteenButtonState extends State<SmartCanteenButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.96,
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
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: SizedBox(
        height: widget.height,
        width: widget.width,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            boxShadow: [
              BoxShadow(
                color: widget.fillColor.withValues(alpha: 0.25),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: _handlePress,
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.fillColor,
              foregroundColor: widget.textColor,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widget.radius),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.leading != null) ...[
                  widget.leading!,
                  const SizedBox(width: 10),
                ],
                Text(
                  widget.label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
