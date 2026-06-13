import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class CouponExpiredOverlay extends StatelessWidget {
  const CouponExpiredOverlay({super.key, required this.onDismiss});

  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.7),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEBEE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.timer_off_rounded, color: Color(0xFFE53935), size: 32),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Coupon Expired',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.text),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your QR ticket has expired. Please purchase a new coupon to continue.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppTheme.mutedText, fontSize: 13, height: 1.5),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onDismiss,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.green,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Get New Coupon', style: TextStyle(fontWeight: FontWeight.w600)),
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
