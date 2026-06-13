import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../theme/app_theme.dart';
import '../../widgets/smart_canteen_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static const routeName = '/profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _profileImage;
  final _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 512,
      maxHeight: 512,
    );
    if (picked != null && mounted) {
      setState(() => _profileImage = File(picked.path));
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Change Profile Photo',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.text,
                ),
              ),
              const SizedBox(height: 16),
              _PickerOption(
                icon: Icons.camera_alt_rounded,
                label: 'Take Photo',
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.camera);
                },
              ),
              const SizedBox(height: 10),
              _PickerOption(
                icon: Icons.photo_library_rounded,
                label: 'Choose from Gallery',
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.gallery);
                },
              ),
              if (_profileImage != null) ...[
                const SizedBox(height: 10),
                _PickerOption(
                  icon: Icons.delete_outline_rounded,
                  label: 'Remove Photo',
                  isDestructive: true,
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() => _profileImage = null);
                  },
                ),
              ],
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // ── Gradient header ───────────────────────────────────────────────
          Container(
            padding: EdgeInsets.fromLTRB(
              20,
              MediaQuery.of(context).padding.top + 16,
              20,
              32,
            ),
            decoration: BoxDecoration(gradient: AppTheme.headerGradient),
            child: Column(
              children: [
                // Top bar
                Row(
                  children: [
                    const Text(
                      'My Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Settings — coming soon'),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: AppTheme.green,
                        ),
                      ),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: const Icon(
                          Icons.settings_outlined,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Avatar with camera button
                GestureDetector(
                  onTap: _showImageSourceSheet,
                  child: Stack(
                    children: [
                      Container(
                        width: 86,
                        height: 86,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 18,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: _profileImage != null
                              ? Image.file(
                                  _profileImage!,
                                  fit: BoxFit.cover,
                                  width: 86,
                                  height: 86,
                                )
                              : const Center(
                                  child: Text(
                                    'JD',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.green,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.12),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            size: 14,
                            color: AppTheme.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'John Doe',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'john.doe@cadt.edu.kh',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Text(
                    'CADT Scholar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Stats card ────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    const Expanded(
                        child: _StatItem(value: '24', label: 'Orders')),
                    VerticalDivider(
                      width: 1,
                      color: AppTheme.border,
                      indent: 8,
                      endIndent: 8,
                    ),
                    const Expanded(
                        child: _StatItem(value: '\$16.25', label: 'Balance')),
                    VerticalDivider(
                      width: 1,
                      color: AppTheme.border,
                      indent: 8,
                      endIndent: 8,
                    ),
                    const Expanded(
                        child: _StatItem(value: '320', label: 'Points')),
                  ],
                ),
              ),
            ),
          ),

          // ── Menu items card ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: _buildMenuItems(context),
              ),
            ),
          ),

          // ── Logout button ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            child: GestureDetector(
              onTap: () =>
                  Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false),
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFFCDD2)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout_rounded,
                        color: Color(0xFFE53935), size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Log Out',
                      style: TextStyle(
                        color: Color(0xFFE53935),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SmartCanteenNavigationBarButton(
        currentIndex: 4,
        onTap: (i) => _onNavTap(context, i),
      ),
    );
  }

  List<Widget> _buildMenuItems(BuildContext context) {
    final items = [
      (Icons.edit_outlined, 'Edit Profile', 'Update your info'),
      (Icons.credit_card_outlined, 'Payment Methods', 'Manage your cards'),
      (Icons.history, 'Order History', 'View past orders'),
      (Icons.notifications_outlined, 'Notifications', 'Set your preferences'),
      (Icons.info_outline, 'About', 'App info & version'),
    ];

    return List.generate(items.length, (i) {
      final item = items[i];
      final isLast = i == items.length - 1;

      return Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.vertical(
                top: i == 0 ? const Radius.circular(20) : Radius.zero,
                bottom: isLast ? const Radius.circular(20) : Radius.zero,
              ),
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${item.$2} — coming soon'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppTheme.green,
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.greenSurface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(item.$1, color: AppTheme.green, size: 20),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.$2,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.text,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.$3,
                            style: const TextStyle(
                              color: AppTheme.mutedText,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 13,
                      color: AppTheme.mutedText,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (!isLast)
            const Divider(
              indent: 70,
              endIndent: 16,
              height: 1,
              color: AppTheme.border,
            ),
        ],
      );
    });
  }
}

// ── Supporting widgets ────────────────────────────────────────────────────────

class _StatItem extends StatelessWidget {
  const _StatItem({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.green,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppTheme.mutedText),
        ),
      ],
    );
  }
}

class _PickerOption extends StatelessWidget {
  const _PickerOption({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? const Color(0xFFE53935) : AppTheme.green;
    final bgColor =
        isDestructive ? const Color(0xFFFFEBEE) : AppTheme.greenSurface;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 14),
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
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
