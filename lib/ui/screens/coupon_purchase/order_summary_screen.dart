import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/cart_model.dart';
import '../../../models/food_item.dart';
import '../../../theme/app_theme.dart';
import '../../../ui/states/order_history_state.dart';
import '../../widgets/payment_method_sheet.dart';
import '../../widgets/smart_canteen_widgets.dart';

class OrderSummaryScreen extends StatelessWidget {
  const OrderSummaryScreen({super.key});

  static const routeName = '/order-summary';

  void _showPaymentMethodSheet(BuildContext context, double amount) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PaymentMethodSheet(
        totalAmount: amount,
        onConfirm: () => _showPaymentSuccess(context),
      ),
    );
  }

  void _showPaymentSuccess(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.all(28),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppTheme.green.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline,
                color: AppTheme.green,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Payment Successful!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.text,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your order has been placed.\nPlease collect at the counter.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.mutedText, fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: 24),
            SmartCanteenButton(
              label: 'Back to Home',
              onPressed: () {
                final cart = CartProvider.of(context);
                // Build a summary string from the current cart entries
                final itemsLabel = cart.entries
                    .map((e) => e.quantity > 1
                        ? '${e.item.name} ×${e.quantity}'
                        : e.item.name)
                    .join(', ');
                // Push the new order into history as Pending
                final firstEntry =
                    cart.entries.isNotEmpty ? cart.entries.first : null;
                context.read<OrderHistoryState>().addOrder(
                      OrderRecord(
                        date: _formatNow(),
                        items: itemsLabel,
                        total: cart.total,
                        status: 'Pending',
                        imagePath: firstEntry?.item.imagePath,
                        colorSeed: firstEntry?.item.colorSeed ?? 0,
                      ),
                    );
                cart.clear();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home',
                  (_) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartProvider.of(context);
    final entries = cart.entries;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Smart Canteen',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: entries.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.shopping_cart_outlined,
                    size: 64,
                    color: AppTheme.border,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Your cart is empty',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.mutedText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Add items from the menu to get started',
                    style: TextStyle(fontSize: 12, color: AppTheme.mutedText),
                  ),
                  const SizedBox(height: 24),
                  SmartCanteenButton(
                    label: 'Browse Menu',
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/menu'),
                    height: 48,
                    radius: 14,
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Your Order',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.text,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${cart.totalItems} Item${cart.totalItems == 1 ? '' : 's'}',
                          style: const TextStyle(
                            color: AppTheme.green,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: entries.length,
                    separatorBuilder: (_, _) =>
                        const Divider(height: 32, color: AppTheme.border),
                    itemBuilder: (context, index) {
                      return OrderItemCard(
                        entry: entries[index],
                        onIncrement: () =>
                            cart.increment(entries[index].item.id),
                        onDecrement: () =>
                            cart.decrement(entries[index].item.id),
                      );
                    },
                  ),
                ),
                _PaymentSummarySection(
                  cart: cart,
                  onPay: () => _showPaymentMethodSheet(context, cart.total),
                ),
              ],
            ),
      bottomNavigationBar: SmartCanteenNavigationBarButton(
        currentIndex: 1,
        onTap: (i) {
          switch (i) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
            case 1:
              Navigator.pushReplacementNamed(context, '/menu');
            case 2:
              Navigator.pushReplacementNamed(context, '/qr');
            case 3:
              Navigator.pushReplacementNamed(context, '/history');
            case 4:
              Navigator.pushReplacementNamed(context, '/profile');
          }
        },
      ),
    );
  }
}

class OrderItemCard extends StatelessWidget {
  const OrderItemCard({
    super.key,
    required this.entry,
    required this.onIncrement,
    required this.onDecrement,
  });

  final CartEntry entry;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: 80,
            height: 80,
            child: _OrderItemImage(entry: entry),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.item.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.text,
                ),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 6,
                children: entry.item.tags.take(2).map((t) => _SmallTag(label: t)).toList(),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${(entry.item.price * entry.quantity).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.green,
                    ),
                  ),
                  QuantityController(
                    quantity: entry.quantity,
                    onIncrement: onIncrement,
                    onDecrement: onDecrement,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OrderItemImage extends StatelessWidget {
  const _OrderItemImage({required this.entry});
  final CartEntry entry;

  @override
  Widget build(BuildContext context) {
    if (entry.item.imagePath != null) {
      return Image.asset(
        entry.item.imagePath!,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _placeholder(),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() {
    final idx = entry.item.colorSeed % kFoodGradients.length;
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
          size: 32,
        ),
      ),
    );
  }
}

class _SmallTag extends StatelessWidget {
  const _SmallTag({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppTheme.border.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 10, color: AppTheme.mutedText),
      ),
    );
  }
}

class QuantityController extends StatelessWidget {
  const QuantityController({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.remove, size: 16, color: AppTheme.green),
            onPressed: onDecrement,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 30, minHeight: 40),
          ),
          Text(
            '$quantity',
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
          IconButton(
            icon: const Icon(Icons.add, size: 16, color: AppTheme.green),
            onPressed: onIncrement,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 30, minHeight: 40),
          ),
        ],
      ),
    );
  }
}

class _PaymentSummarySection extends StatelessWidget {
  const _PaymentSummarySection({required this.cart, required this.onPay});

  final CartModel cart;
  final VoidCallback onPay;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Column(
        children: [
          _SummaryRow(
            label: 'Subtotal',
            value: '\$${cart.subtotal.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 10),
          if (cart.discount > 0)
            _SummaryRow(
              label: 'Scholar Discount',
              value: '- \$${cart.discount.toStringAsFixed(2)}',
              valueColor: Colors.redAccent,
            ),
          if (cart.discount > 0) const SizedBox(height: 10),
          _SummaryRow(
            label: 'Service Fee',
            value: '\$${cart.serviceFee.toStringAsFixed(2)}',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: AppTheme.border),
          ),
          _SummaryRow(
            label: 'Total Amount',
            value: '\$${cart.total.toStringAsFixed(2)}',
            isTotal: true,
          ),
          const SizedBox(height: 24),
          SmartCanteenButton(
            label: 'Proceed to Payment  →',
            onPressed: onPay,
            height: 56,
            radius: 16,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isTotal = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: isTotal ? AppTheme.text : AppTheme.mutedText,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 22 : 14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
            color: valueColor ?? (isTotal ? AppTheme.green : AppTheme.text),
          ),
        ),
      ],
    );
  }
}

// Returns a human-readable timestamp such as "Today, 2:05 PM".
String _formatNow() {
  final dt = DateTime.now();
  final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
  final m = dt.minute.toString().padLeft(2, '0');
  final period = dt.hour >= 12 ? 'PM' : 'AM';
  return 'Today, $h:$m $period';
}
