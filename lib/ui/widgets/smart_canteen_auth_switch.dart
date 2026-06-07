import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

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
  const _AuthSwitchItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

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
