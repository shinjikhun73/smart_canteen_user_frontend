import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

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
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 10),
            ],
            Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class SmartCanteenTextField extends StatelessWidget {
  const SmartCanteenTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
  });

  final String label;
  final String hintText;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.green,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}

class SmartCanteenAuthSwitch extends StatelessWidget {
  const SmartCanteenAuthSwitch({
    super.key,
    required this.isLoginSelected,
    required this.onLoginTap,
    required this.onSignUpTap,
  });

  final bool isLoginSelected;
  final VoidCallback onLoginTap;
  final VoidCallback onSignUpTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: _AuthSwitchItem(
              label: 'Log In',
              selected: isLoginSelected,
              onTap: onLoginTap,
            ),
          ),
          Expanded(
            child: _AuthSwitchItem(
              label: 'Sign Up',
              selected: !isLoginSelected,
              onTap: onSignUpTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthSwitchItem extends StatelessWidget {
  const _AuthSwitchItem({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppTheme.green : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppTheme.green,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class SmartCanteenDividerText extends StatelessWidget {
  const SmartCanteenDividerText({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppTheme.border, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            label,
            style: const TextStyle(
              color: AppTheme.green,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.9,
            ),
          ),
        ),
        const Expanded(child: Divider(color: AppTheme.border, thickness: 1)),
      ],
    );
  }
}

class SmartCanteenSocialButton extends StatelessWidget {
  const SmartCanteenSocialButton({
    super.key,
    required this.label,
    required this.icon,
  });

  final String label;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppTheme.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.green,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CanteenLogo extends StatelessWidget {
  const CanteenLogo({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final plateSize = size;
    return SizedBox(
      width: plateSize,
      height: plateSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: plateSize * 0.98,
            height: plateSize * 0.98,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppTheme.green.withValues(alpha: 0.08),
                  Colors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned(
            top: plateSize * 0.12,
            left: plateSize * 0.10,
            child: _FoodCircle(
              size: plateSize * 0.28,
              color: const Color(0xFFFFC85C),
              borderColor: Colors.black,
            ),
          ),
          Positioned(
            bottom: plateSize * 0.16,
            left: plateSize * 0.18,
            child: _FoodSlice(size: plateSize * 0.34),
          ),
          Positioned(
            right: plateSize * 0.14,
            top: plateSize * 0.16,
            child: Transform.rotate(
              angle: math.pi / 8,
              child: Container(
                width: plateSize * 0.36,
                height: plateSize * 0.30,
                decoration: BoxDecoration(
                  color: const Color(0xFFB56D42),
                  border: Border.all(color: Colors.black, width: 4),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(14),
                    bottomLeft: Radius.circular(4),
                    bottomRight: Radius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: plateSize * 0.08,
            right: plateSize * 0.10,
            child: Container(
              width: plateSize * 0.16,
              height: plateSize * 0.16,
              decoration: BoxDecoration(
                color: const Color(0xFF57A957),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 4),
              ),
              child: const Icon(Icons.restaurant, color: Colors.white, size: 16),
            ),
          ),
          Container(
            width: plateSize * 0.82,
            height: plateSize * 0.82,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 5),
            ),
          ),
        ],
      ),
    );
  }
}

class _FoodCircle extends StatelessWidget {
  const _FoodCircle({required this.size, required this.color, required this.borderColor});

  final double size;
  final Color color;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 4),
      ),
    );
  }
}

class _FoodSlice extends StatelessWidget {
  const _FoodSlice({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFE05A4E),
        borderRadius: BorderRadius.circular(size * 0.15),
        border: Border.all(color: Colors.black, width: 4),
      ),
    );
  }
}

class FancyCard extends StatelessWidget {
  const FancyCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.backgroundColor = Colors.white,
    this.radius = 18,
  });

  final Widget child;
  final EdgeInsets padding;
  final Color backgroundColor;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class MenuChip extends StatelessWidget {
  const MenuChip({super.key, required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? AppTheme.green : Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppTheme.border),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : AppTheme.green,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}