import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../theme/app_theme.dart';
import '../../../ui/states/order_history_state.dart';
import '../../widgets/smart_canteen_widgets.dart';

// ── Screen-scoped palette ────────────────────────────────────────────────────
const Color _kNavy = Color(0xFF1E3D59);
const Color _kNavyMid = Color(0xFF254B6D);
const Color _kNavyDeep = Color(0xFF152D42);
const Color _kSky = Color(0xFFA6CDFF); // same as AppTheme.accentBlue

// ─────────────────────────────────────────────────────────────────────────────
// QrScreen
// ─────────────────────────────────────────────────────────────────────────────

class QrScreen extends StatefulWidget {
  const QrScreen({super.key});
  static const routeName = '/qr';

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen>
    with SingleTickerProviderStateMixin {
  String _session = 'Breakfast';

  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _refreshQr() {
    _pulseCtrl.forward(from: 0);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('QR code refreshed'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: _kNavy,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      ),
    );
  }

  void _showReceiptSheet(BuildContext ctx, OrderRecord order) {
    showModalBottomSheet<void>(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ReceiptSheet(order: order),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrderHistoryState>().orders;
    final latest = orders.isNotEmpty ? orders.first : null;
    final isPaid = latest?.status == 'Completed';

    return Scaffold(
      backgroundColor: context.bgColor,
      appBar: AppBar(
        backgroundColor: context.bgColor,
        elevation: 0,
        titleSpacing: 20,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'My Meal Ticket',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
            Text(
              _fmtDate(DateTime.now()),
              style: TextStyle(
                fontSize: 11,
                color: context.mutedColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Column(
          children: [
            // ── Ticket card ──────────────────────────────────────────────────
            _TicketCard(
              session: _session,
              isPaid: isPaid,
              pulseAnim: _pulseAnim,
            ),
            const SizedBox(height: 20),
            // ── Session selector ─────────────────────────────────────────────
            _SessionSelector(
              selected: _session,
              onSelect: (s) => setState(() => _session = s),
            ),
            const SizedBox(height: 20),
            // ── Order summary ────────────────────────────────────────────────
            if (latest != null)
              _OrderSummaryCard(order: latest)
            else
              _EmptyOrderCard(),
            const SizedBox(height: 24),
            // ── Primary action ───────────────────────────────────────────────
            SmartCanteenButton(
              label: 'Refresh QR Code',
              leading: const Icon(
                Icons.refresh_rounded,
                size: 18,
                color: Colors.white,
              ),
              fillColor: _kNavy,
              height: 52,
              radius: 16,
              onPressed: _refreshQr,
            ),
            const SizedBox(height: 12),
            // ── Secondary action ─────────────────────────────────────────────
            if (latest != null)
              SmartCanteenButton(
                label: 'View Receipt',
                leading: Icon(
                  Icons.receipt_long_outlined,
                  size: 18,
                  color: _kNavy,
                ),
                fillColor: _kNavy.withValues(alpha: 0.08),
                textColor: _kNavy,
                height: 52,
                radius: 16,
                onPressed: () => _showReceiptSheet(context, latest),
              ),
          ],
        ),
      ),
    );
  }
}

String _fmtDate(DateTime dt) {
  const m = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  const d = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  return '${d[dt.weekday - 1]}, ${m[dt.month - 1]} ${dt.day}, ${dt.year}';
}

// ─────────────────────────────────────────────────────────────────────────────
// Ticket Card — navy gradient with user info, tear line, and QR code
// ─────────────────────────────────────────────────────────────────────────────

class _TicketCard extends StatelessWidget {
  const _TicketCard({
    required this.session,
    required this.isPaid,
    required this.pulseAnim,
  });

  final String session;
  final bool isPaid;
  final Animation<double> pulseAnim;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_kNavyDeep, _kNavy, _kNavyMid],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _kNavy.withValues(alpha: 0.38),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── User info ───────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _kSky.withValues(alpha: 0.16),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _kSky.withValues(alpha: 0.35),
                      width: 1.5,
                    ),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: _kSky,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'John Doe',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'ID: 20230042  ·  CADT Scholar',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                // Session badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: _kSky.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _kSky.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        session == 'Breakfast'
                            ? Icons.wb_sunny_outlined
                            : Icons.lunch_dining_outlined,
                        color: _kSky,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        session,
                        style: const TextStyle(
                          color: _kSky,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // ── Tear-line ───────────────────────────────────────────────────
          SizedBox(
            height: 22,
            width: double.infinity,
            child: CustomPaint(
              painter: _TearLinePainter(bgColor: context.bgColor),
            ),
          ),
          // ── QR code section ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ScaleTransition(
                      scale: pulseAnim,
                      child: Container(
                        width: 210,
                        height: 210,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.28),
                              blurRadius: 28,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(14),
                        child: const _QrPlaceholder(),
                      ),
                    ),
                    // Status badge anchored to QR top-right
                    Positioned(
                      top: -10,
                      right: -10,
                      child: _StatusBadge(isPaid: isPaid),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  'Show this code at the canteen counter\nto collect your meal',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.62),
                    fontSize: 12,
                    height: 1.65,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tear-line painter — dashed line + half-circle notches in bgColor
// ─────────────────────────────────────────────────────────────────────────────

class _TearLinePainter extends CustomPainter {
  const _TearLinePainter({required this.bgColor});
  final Color bgColor;

  @override
  void paint(Canvas canvas, Size size) {
    final midY = size.height / 2;

    // Half-circle notches (background color painted over the navy card edges)
    final notchPaint = Paint()
      ..color = bgColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(0, midY), 11, notchPaint);
    canvas.drawCircle(Offset(size.width, midY), 11, notchPaint);

    // Dashed line between notches
    final dashPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.22)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    const dashW = 6.0;
    const gap = 4.5;
    double x = 14.0;
    while (x < size.width - 14) {
      canvas.drawLine(Offset(x, midY), Offset(x + dashW, midY), dashPaint);
      x += dashW + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _TearLinePainter old) => old.bgColor != bgColor;
}

// ─────────────────────────────────────────────────────────────────────────────
// Status Badge
// ─────────────────────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.isPaid});
  final bool isPaid;

  @override
  Widget build(BuildContext context) {
    final color = isPaid ? AppTheme.green : const Color(0xFFFF9800);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.45),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPaid
                ? Icons.check_circle_rounded
                : Icons.access_time_rounded,
            color: Colors.white,
            size: 12,
          ),
          const SizedBox(width: 4),
          Text(
            isPaid ? 'PAID' : 'PENDING',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// QR Placeholder — navy dots on white background
// ─────────────────────────────────────────────────────────────────────────────

class _QrPlaceholder extends StatelessWidget {
  const _QrPlaceholder();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _QrPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _QrPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _kNavy
      ..style = PaintingStyle.fill;

    const cols = 19;
    final cell = size.width / cols;

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
                c * cell + 1,
                r * cell + 1,
                cell - 2,
                cell - 2,
              ),
              const Radius.circular(2),
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

// ─────────────────────────────────────────────────────────────────────────────
// Session Selector
// ─────────────────────────────────────────────────────────────────────────────

class _SessionSelector extends StatelessWidget {
  const _SessionSelector({
    required this.selected,
    required this.onSelect,
  });

  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SessionChip(
          icon: Icons.wb_sunny_outlined,
          label: 'Breakfast',
          time: '7:00 – 9:00 AM',
          isSelected: selected == 'Breakfast',
          onTap: () => onSelect('Breakfast'),
        ),
        const SizedBox(width: 12),
        _SessionChip(
          icon: Icons.lunch_dining_outlined,
          label: 'Lunch',
          time: '11:00 AM – 1:00 PM',
          isSelected: selected == 'Lunch',
          onTap: () => onSelect('Lunch'),
        ),
      ],
    );
  }
}

class _SessionChip extends StatelessWidget {
  const _SessionChip({
    required this.icon,
    required this.label,
    required this.time,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String time;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected
                ? _kNavy.withValues(alpha: 0.07)
                : context.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? _kNavy : context.borderColor,
              width: isSelected ? 1.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? _kNavy : context.mutedColor,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: isSelected ? _kNavy : context.textColor,
                      ),
                    ),
                    Text(
                      time,
                      style: TextStyle(fontSize: 9, color: context.mutedColor),
                    ),
                  ],
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isSelected ? 1.0 : 0.0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: _kNavy,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Order Summary Card
// ─────────────────────────────────────────────────────────────────────────────

class _OrderSummaryCard extends StatelessWidget {
  const _OrderSummaryCard({required this.order});
  final OrderRecord order;

  @override
  Widget build(BuildContext context) {
    final items = order.items
        .split(', ')
        .where((s) => s.isNotEmpty)
        .toList();

    return FancyCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: _kNavy.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.receipt_outlined,
                      color: _kNavy,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Order Summary',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: context.textColor,
                    ),
                  ),
                ],
              ),
              Text(
                order.date,
                style: TextStyle(fontSize: 11, color: context.mutedColor),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Item list
          ...items.map((raw) => _ItemRow(raw: raw)),
          // Divider
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1, color: context.borderColor),
          ),
          // Total
          _DetailRow(
            label: 'Total Paid',
            value: '\$${order.total.toStringAsFixed(2)}',
            valueStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.green,
            ),
          ),
          const SizedBox(height: 12),
          // Payment method
          _DetailRow(
            label: 'Payment Method',
            value: 'Wallet',
            icon: Icons.account_balance_wallet_rounded,
          ),
        ],
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.raw});
  final String raw;

  @override
  Widget build(BuildContext context) {
    final parts = raw.split(' ×');
    final name = parts[0].trim();
    final qty = parts.length > 1 ? parts[1] : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 7,
            height: 7,
            margin: const EdgeInsets.only(top: 1),
            decoration: const BoxDecoration(
              color: _kSky,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: context.textColor,
              ),
            ),
          ),
          if (qty != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: _kNavy.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '×$qty',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: _kNavy,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.valueStyle,
    this.icon,
  });

  final String label;
  final String value;
  final TextStyle? valueStyle;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final defaultStyle = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: context.textColor,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13, color: context.mutedColor),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: _kNavy),
              const SizedBox(width: 5),
            ],
            Text(value, style: valueStyle ?? defaultStyle),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty order placeholder
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyOrderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FancyCard(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      child: Column(
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 40,
            color: context.borderColor,
          ),
          const SizedBox(height: 10),
          Text(
            'No orders yet',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: context.mutedColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Place an order from the menu\nto generate your ticket',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: context.mutedColor),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Receipt Bottom Sheet
// ─────────────────────────────────────────────────────────────────────────────

class _ReceiptSheet extends StatelessWidget {
  const _ReceiptSheet({required this.order});
  final OrderRecord order;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.72,
      minChildSize: 0.5,
      maxChildSize: 0.92,
      expand: false,
      builder: (_, ctrl) {
        return Container(
          decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SingleChildScrollView(
            controller: ctrl,
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // drag handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: context.borderColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                // Header
                Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: _kNavy.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.receipt_long_rounded,
                        color: _kNavy,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Transaction Receipt',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: context.textColor,
                          ),
                        ),
                        Text(
                          order.date,
                          style: TextStyle(
                            fontSize: 12,
                            color: context.mutedColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Items block
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.bgColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: order.items
                        .split(', ')
                        .where((s) => s.isNotEmpty)
                        .map((raw) {
                      final parts = raw.split(' ×');
                      final name = parts[0].trim();
                      final qty =
                          parts.length > 1 ? int.tryParse(parts[1]) ?? 1 : 1;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                name,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: context.textColor,
                                ),
                              ),
                            ),
                            Text(
                              '×$qty',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: context.mutedColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
                Divider(color: context.borderColor),
                const SizedBox(height: 16),
                _ReceiptRow(
                  label: 'Total',
                  value: '\$${order.total.toStringAsFixed(2)}',
                  valueColor: AppTheme.green,
                  isBold: true,
                ),
                const SizedBox(height: 12),
                _ReceiptRow(
                  label: 'Status',
                  value: order.status,
                  valueColor: order.status == 'Completed'
                      ? AppTheme.green
                      : const Color(0xFFFF9800),
                ),
                const SizedBox(height: 12),
                const _ReceiptRow(
                  label: 'Payment Method',
                  value: 'Wallet',
                ),
                const SizedBox(height: 12),
                _ReceiptRow(
                  label: 'Reference',
                  value: '#SC${order.date.hashCode.abs() % 90000 + 10000}',
                ),
                const SizedBox(height: 32),
                SmartCanteenButton(
                  label: 'Close',
                  fillColor: _kNavy,
                  height: 52,
                  radius: 16,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ReceiptRow extends StatelessWidget {
  const _ReceiptRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isBold = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13, color: context.mutedColor),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 17 : 13,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
            color: valueColor ?? context.textColor,
          ),
        ),
      ],
    );
  }
}
