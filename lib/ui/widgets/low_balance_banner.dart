import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class LowBalanceBanner extends StatelessWidget {
  const LowBalanceBanner({super.key, required this.onTopUp});

  final VoidCallback onTopUp;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: const Color(0xFFFFF3E0),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Color(0xFFE65100), size: 18),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Low balance — top up to keep ordering',
              style: TextStyle(fontSize: 12, color: Color(0xFFE65100), fontWeight: FontWeight.w500),
            ),
          ),
          GestureDetector(
            onTap: onTopUp,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: AppTheme.green,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Top Up',
                style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
