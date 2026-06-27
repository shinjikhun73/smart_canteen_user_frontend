import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class SmartCanteenTextField extends StatefulWidget {
  const SmartCanteenTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.controller,
    this.keyboardType,
  });

  final String label;
  final String hintText;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextEditingController? controller;
  final TextInputType? keyboardType;

  @override
  State<SmartCanteenTextField> createState() => _SmartCanteenTextFieldState();
}

class _SmartCanteenTextFieldState extends State<SmartCanteenTextField>
    with SingleTickerProviderStateMixin {
  late bool _obscure;
  late FocusNode _focusNode;
  late AnimationController _focusController;
  late Animation<double> _focusAnimation;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
    _focusNode = FocusNode();
    _focusController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _focusAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _focusController, curve: Curves.easeOutCubic),
    );

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _focusController.forward();
      } else {
        _focusController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _focusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            color: AppTheme.green,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 10),
        AnimatedBuilder(
          animation: _focusAnimation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.green.withValues(
                      alpha: 0.1 * _focusAnimation.value,
                    ),
                    blurRadius: 8 * _focusAnimation.value,
                    offset: Offset(0, 2 * _focusAnimation.value),
                  ),
                ],
              ),
              child: TextFormField(
                focusNode: _focusNode,
                controller: widget.controller,
                obscureText: _obscure,
                keyboardType: widget.keyboardType,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: const TextStyle(
                    color: AppTheme.mutedText,
                    fontWeight: FontWeight.w400,
                  ),
                  prefixIcon: widget.prefixIcon,
                  suffixIcon: widget.obscureText
                      ? GestureDetector(
                          onTap: () => setState(() => _obscure = !_obscure),
                          child: Icon(
                            _obscure
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: AppTheme.mutedText,
                            size: 20,
                          ),
                        )
                      : widget.suffixIcon,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFFE8E8E8),
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Color.lerp(
                        const Color(0xFFE8E8E8),
                        AppTheme.green,
                        _focusAnimation.value * 0.3,
                      )!,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Color.lerp(
                        const Color(0xFFE8E8E8),
                        AppTheme.green,
                        _focusAnimation.value,
                      )!,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Color.lerp(
                    Colors.white,
                    AppTheme.green.withValues(alpha: 0.02),
                    _focusAnimation.value,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
