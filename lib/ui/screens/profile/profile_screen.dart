import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../widgets/smart_canteen_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.border,
                    border: Border.all(color: AppTheme.green, width: 3),
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 48,
                    color: AppTheme.green,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'John Doe',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.text,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'john.doe@cadt.edu.kh',
                  style: TextStyle(fontSize: 13, color: AppTheme.mutedText),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'CADT Scholar',
                    style: TextStyle(
                      color: AppTheme.green,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _StatCard(label: 'Orders', value: '24'),
              const SizedBox(width: 12),
              _StatCard(label: 'Balance', value: '16.25'),
              const SizedBox(width: 12),
              _StatCard(label: 'Points', value: '320'),
            ],
          ),
          const SizedBox(height: 24),
          ..._menuItems(context),
        ],
      ),
      bottomNavigationBar: SmartCanteenNavigationBarButton(
        currentIndex: 4,
        onTap: (i) => _onNavTap(context, i),
      ),
    );
  }

  List<Widget> _menuItems(BuildContext context) {
    final items = [
      (Icons.edit_outlined, 'Edit Profile'),
      (Icons.credit_card_outlined, 'Payment Methods'),
      (Icons.history, 'Order History'),
      (Icons.notifications_outlined, 'Notifications'),
      (Icons.info_outline, 'About'),
    ];

    return [
      ...items.map(
        (item) => Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.border.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item.$1, color: AppTheme.green, size: 20),
              ),
              title: Text(
                item.$2,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppTheme.text,
                ),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                color: AppTheme.mutedText,
              ),
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${item.$2} — coming soon'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppTheme.green,
                ),
              ),
            ),
            const Divider(color: AppTheme.border, height: 1),
          ],
        ),
      ),
      const SizedBox(height: 16),
      SmartCanteenButton(
        label: 'Log Out',
        fillColor: const Color(0xFFFFEBEE),
        textColor: Colors.redAccent,
        onPressed: () =>
            Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false),
      ),
    ];
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FancyCard(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.green,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: AppTheme.mutedText),
            ),
          ],
        ),
      ),
    );
  }
}

void _onNavTap(BuildContext context, int index) {
  switch (index) {
    case 0:
      Navigator.pushReplacementNamed(context, '/home');
    case 1:
      Navigator.pushReplacementNamed(context, '/menu');
    case 2:
      Navigator.pushReplacementNamed(context, '/qr');
    case 3:
      Navigator.pushReplacementNamed(context, '/history');
    case 4:
      break;
  }
}
