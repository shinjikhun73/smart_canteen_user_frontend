import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class SmartCanteenButton extends StatelessWidget {
  const SmartCanteenButton({
    super.key,
    required this.label,
    this.onPressed,
    this.fillColor = AppTheme.green,
    this.textColor = Colors.white,
    this.height = 52,
    this.radius = 16,
    this.leading,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color fillColor;
  final Color textColor;
  final double height;
  final double radius;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: fillColor,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 10)],
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
