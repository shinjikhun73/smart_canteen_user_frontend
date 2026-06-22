import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/food_item.dart';
import '../../../theme/app_theme.dart';
import '../../../ui/states/order_history_state.dart';
import '../../widgets/smart_canteen_widgets.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  static const routeName = '/history';

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrderHistoryState>().orders;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order History',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: orders.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.receipt_long_outlined,
                      size: 56, color: context.borderColor),
                  const SizedBox(height: 12),
                  Text(
                    'No orders yet',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: context.mutedColor,
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _OrderCard(order: orders[i]),
            ),
    );
  }
}

class _OrderCard extends StatefulWidget {
  const _OrderCard({required this.order});
  final OrderRecord order;

  @override
  State<_OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<_OrderCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _expandController;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _expandController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _expandController.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() => _isExpanded = !_isExpanded);
    if (_isExpanded) {
      _expandController.forward();
    } else {
      _expandController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final isDeposit = order.type == 'deposit';
    final isPending = order.status == 'Pending';
    final isFailed = order.status == 'Failed';

    const kPending = Color(0xFFFF9800);
    const kRed = Color(0xFFE53935);

    final statusBg = isPending
        ? kPending.withValues(alpha: 0.12)
        : isFailed
            ? kRed.withValues(alpha: 0.1)
            : AppTheme.green.withValues(alpha: 0.1);
    final statusFg = isPending
        ? kPending
        : isFailed
            ? kRed
            : AppTheme.green;

    final amountColor = isFailed
        ? context.mutedColor
        : isDeposit
            ? AppTheme.green
            : isPending
                ? kPending
                : kRed;
    final amountLabel = isDeposit
        ? '+\$${order.total.toStringAsFixed(2)}'
        : '-\$${order.total.toStringAsFixed(2)}';

    return GestureDetector(
      onTap: _toggleExpand,
      child: AnimatedBuilder(
        animation: _expandController,
        builder: (context, child) {
          return FancyCard(
            padding: const EdgeInsets.all(14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        width: 52,
                        height: 52,
                        child: isDeposit
                            ? const _DepositThumbnail()
                            : _FoodThumbnail(order: order),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.items,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            order.date,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppTheme.mutedText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          amountLabel,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: amountColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: statusBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            order.status,
                            style: TextStyle(
                              fontSize: 10,
                              color: statusFg,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (_isExpanded) ...[
                  const SizedBox(height: 12),
                  Divider(height: 1, color: context.borderColor),
                  const SizedBox(height: 12),
                  isDeposit
                      ? _DepositDetails(order: order)
                      : _FoodOrderDetails(order: order),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FoodThumbnail extends StatelessWidget {
  const _FoodThumbnail({required this.order});
  final OrderRecord order;

  @override
  Widget build(BuildContext context) {
    if (order.imagePath != null) {
      return Image.asset(
        order.imagePath!,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _placeholder(),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() {
    final idx = order.colorSeed % kFoodGradients.length;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: kFoodGradients[idx],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          kFoodIcons[idx % kFoodIcons.length],
          color: AppTheme.green,
          size: 22,
        ),
      ),
    );
  }
}

class _DepositThumbnail extends StatelessWidget {
  const _DepositThumbnail();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.green.withValues(alpha: 0.12),
      child: const Center(
        child: Icon(
          Icons.account_balance_wallet_rounded,
          color: AppTheme.green,
          size: 26,
        ),
      ),
    );
  }
}

// ── Expanded view for food orders ─────────────────────────────────────────

class _FoodOrderDetails extends StatelessWidget {
  const _FoodOrderDetails({required this.order});
  final OrderRecord order;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DetailRow(
          label: 'Items',
          value: order.items,
          valueStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.green,
          ),
        ),
        const SizedBox(height: 10),
        _DetailRow(
          label: 'Total Amount',
          value: '\$${order.total.toStringAsFixed(2)}',
          valueStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppTheme.green,
          ),
        ),
        const SizedBox(height: 8),
        _DetailRow(
          label: 'In KHR',
          value: '៛${(order.total * 4000).toStringAsFixed(0)}',
          valueStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: context.mutedColor,
          ),
        ),
        const SizedBox(height: 10),
        _DetailRow(
          label: 'Payment Method',
          value: 'Wallet',
          valueStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.green,
          ),
        ),
        const SizedBox(height: 8),
        _DetailRow(
          label: 'Status',
          value: order.status,
          valueStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: order.status == 'Completed'
                ? AppTheme.green
                : const Color(0xFFFF9800),
          ),
        ),
      ],
    );
  }
}

// ── Expanded view for deposits ────────────────────────────────────────────

class _DepositDetails extends StatelessWidget {
  const _DepositDetails({required this.order});
  final OrderRecord order;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppTheme.green.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: AppTheme.green,
              size: 32,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            'Top-Up Successful',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: context.textColor,
            ),
          ),
        ),
        const SizedBox(height: 12),
        _DetailRow(
          label: 'Amount Added',
          value: '+\$${order.total.toStringAsFixed(2)}',
          valueStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppTheme.green,
          ),
        ),
        const SizedBox(height: 8),
        _DetailRow(
          label: 'In KHR',
          value: '+៛${(order.total * 4000).toStringAsFixed(0)}',
          valueStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: context.mutedColor,
          ),
        ),
        const SizedBox(height: 10),
        _DetailRow(
          label: 'Payment Method',
          value: 'Bank Transfer',
          valueStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.green,
          ),
        ),
        const SizedBox(height: 8),
        _DetailRow(
          label: 'Transaction ID',
          value: order.id.substring(0, 8).toUpperCase(),
          valueStyle: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: context.mutedColor,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }
}

// ── Detail row helper ──────────────────────────────────────────────────────

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.valueStyle,
  });

  final String label;
  final String value;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: context.mutedColor,
          ),
        ),
        Text(
          value,
          style: valueStyle ??
              const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
