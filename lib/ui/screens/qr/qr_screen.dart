import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../widgets/smart_canteen_widgets.dart';

class QrScreen extends StatelessWidget {
  const QrScreen({super.key});

  static const routeName = '/qr';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Meal Ticket',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 16),
            FancyCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
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
                    'CADT Scholar · Student ID: 20230042',
                    style: TextStyle(fontSize: 12, color: AppTheme.mutedText),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.border, width: 2),
                      color: Colors.white,
                    ),
                    child: const _QrPlaceholder(),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Scan this code at the canteen counter\nto get your meal',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.mutedText,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                _MealChip(
                  icon: Icons.wb_sunny_outlined,
                  label: 'Breakfast',
                  time: '7:00 – 9:00 AM',
                  active: true,
                ),
                const SizedBox(width: 12),
                _MealChip(
                  icon: Icons.lunch_dining_outlined,
                  label: 'Lunch',
                  time: '11:00 AM – 1:00 PM',
                  active: false,
                ),
              ],
            ),
            const Spacer(),
            SmartCanteenButton(
              label: 'Refresh QR Code',
              leading: const Icon(Icons.refresh, size: 18, color: Colors.white),
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('QR code refreshed'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppTheme.green,
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
      bottomNavigationBar: SmartCanteenNavigationBarButton(
        currentIndex: 2,
        onTap: (i) => _onNavTap(context, i),
      ),
    );
  }
}

class _QrPlaceholder extends StatelessWidget {
  const _QrPlaceholder();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _QrPainter(),
      child: const SizedBox(width: 200, height: 200),
    );
  }
}

class _QrPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.green
      ..style = PaintingStyle.fill;

    const cell = 8.0;
    const cols = 21;
    final offset = (size.width - cols * cell) / 2;

    // Simplified QR-style decorative grid
    const pattern = [
      [1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1],
      [1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 1],
      [1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1],
      [1, 0, 1, 1, 1, 0, 1, 0, 0, 1, 0, 1, 1, 0, 1, 1, 1, 0, 1],
      [1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1],
      [1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 1],
      [1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0],
      [1, 0, 1, 1, 0, 1, 1, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1],
      [0, 1, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 0],
      [1, 0, 1, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1, 1, 0, 1],
      [0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0],
      [1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1, 1],
      [1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 0],
      [1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1, 1],
      [1, 0, 1, 1, 1, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 0],
      [1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1, 1],
      [1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 0],
      [1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1, 1],
    ];

    for (int r = 0; r < pattern.length; r++) {
      for (int c = 0; c < pattern[r].length; c++) {
        if (pattern[r][c] == 1) {
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(
                offset + c * cell + 1,
                offset + r * cell + 1,
                cell - 2,
                cell - 2,
              ),
              const Radius.circular(1.5),
            ),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MealChip extends StatelessWidget {
  const _MealChip({
    required this.icon,
    required this.label,
    required this.time,
    required this.active,
  });

  final IconData icon;
  final String label;
  final String time;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FancyCard(
        padding: const EdgeInsets.all(12),
        backgroundColor: active ? const Color(0xFFF4FFE9) : Colors.white,
        child: Row(
          children: [
            Icon(icon, color: AppTheme.green, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: AppTheme.green,
                    ),
                  ),
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 9,
                      color: AppTheme.mutedText,
                    ),
                  ),
                ],
              ),
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
      break;
    case 3:
      Navigator.pushReplacementNamed(context, '/history');
    case 4:
      Navigator.pushReplacementNamed(context, '/profile');
  }
}
