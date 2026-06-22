import 'package:flutter/foundation.dart';

class OrderRecord {
  const OrderRecord({
    required this.id,
    required this.date,
    required this.items,
    required this.total,
    required this.status,
    this.type = 'order',
    this.session,
    this.imagePath,
    this.colorSeed = 0,
  });

  final String id;
  final String date;
  final String items;
  final double total;

  /// 'Pending', 'Completed', or 'Failed'.
  final String status;

  /// 'order' or 'deposit'.
  final String type;

  /// 'Breakfast' or 'Lunch' for food orders; null for deposits.
  final String? session;

  /// First item's asset path — null falls back to gradient placeholder.
  final String? imagePath;

  /// Controls which gradient/icon slot is used for the placeholder.
  final int colorSeed;
}

class OrderHistoryState extends ChangeNotifier {
  final List<OrderRecord> _orders = [
    const OrderRecord(
      id: 'seed-1',
      date: 'Yesterday, 11:45 AM',
      items: 'Pork with Rice, Coconut Milk Tea',
      total: 2.75,
      status: 'Completed',
      session: 'Lunch',
      imagePath: 'asset/foods/pork with rice.png',
      colorSeed: 1,
    ),
    const OrderRecord(
      id: 'seed-2',
      date: 'Jun 12, 3:00 PM',
      items: 'Wallet Top-up',
      total: 5.00,
      status: 'Completed',
      type: 'deposit',
    ),
    const OrderRecord(
      id: 'seed-3',
      date: 'Jun 10, 7:30 AM',
      items: 'Khmer Noodle',
      total: 2.00,
      status: 'Completed',
      session: 'Breakfast',
      imagePath: 'asset/foods/khmer noodle.png',
      colorSeed: 0,
    ),
    const OrderRecord(
      id: 'seed-4',
      date: 'Jun 9, 12:00 PM',
      items: 'Chicken with Rice, Sugarcane Juice',
      total: 2.75,
      status: 'Completed',
      session: 'Lunch',
      imagePath: 'asset/foods/chicken with rice.png',
      colorSeed: 2,
    ),
    const OrderRecord(
      id: 'seed-5',
      date: 'Jun 7, 11:30 AM',
      items: 'Beef Lok Lak, Coconut Milk Tea',
      total: 4.00,
      status: 'Completed',
      session: 'Lunch',
      imagePath: 'asset/foods/beef lok lak.png',
      colorSeed: 3,
    ),
  ];

  List<OrderRecord> get orders => List.unmodifiable(_orders);

  /// Inserts a new order at the top of the list.
  void addOrder(OrderRecord order) {
    _orders.insert(0, order);
    notifyListeners();
  }

  /// Updates the status of the order with [id], if it exists.
  void updateOrderStatus(String id, String newStatus) {
    final idx = _orders.indexWhere((o) => o.id == id);
    if (idx == -1) return;
    final old = _orders[idx];
    _orders[idx] = OrderRecord(
      id: old.id,
      date: old.date,
      items: old.items,
      total: old.total,
      status: newStatus,
      type: old.type,
      session: old.session,
      imagePath: old.imagePath,
      colorSeed: old.colorSeed,
    );
    notifyListeners();
  }
}
