import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../widgets/smart_canteen_widgets.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  static const routeName = '/history';

  static const _orders = [
    _OrderRecord(
      date: 'Today, 11:45 AM',
      items: 'Pork with Rice, Coconut Milk Tea',
      total: 2.75,
      status: 'Completed',
    ),
    _OrderRecord(
      date: 'Yesterday, 7:30 AM',
      items: 'Khmer Noodle',
      total: 2.00,
      status: 'Completed',
    ),
    _OrderRecord(
      date: 'Jun 9, 12:00 PM',
      items: 'Chicken with Rice, Sugarcane Juice',
      total: 2.75,
      status: 'Completed',
    ),
    _OrderRecord(
      date: 'Jun 8, 7:15 AM',
      items: 'Bai Sach Chrouk',
      total: 1.50,
      status: 'Completed',
    ),
    _OrderRecord(
      date: 'Jun 7, 11:30 AM',
      items: 'Beef Lok Lak, Coconut Milk Tea',
      total: 4.00,
      status: 'Completed',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order History',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _orders.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (_, i) => _OrderCard(order: _orders[i]),
      ),
      bottomNavigationBar: SmartCanteenNavigationBarButton(
        currentIndex: 3,
        onTap: (i) => _onNavTap(context, i),
      ),
    );
  }
}

class _OrderRecord {
  final String date;
  final String items;
  final double total;
  final String status;

  const _OrderRecord({
    required this.date,
    required this.items,
    required this.total,
    required this.status,
  });
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});
  final _OrderRecord order;

  @override
  Widget build(BuildContext context) {
    return FancyCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.receipt_long_outlined,
              color: AppTheme.green,
              size: 22,
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
                '\$${order.total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.green,
                ),
              ),
              const SizedBox(height: 3),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Completed',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppTheme.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
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
      break;
    case 4:
      Navigator.pushReplacementNamed(context, '/profile');
  }
}
