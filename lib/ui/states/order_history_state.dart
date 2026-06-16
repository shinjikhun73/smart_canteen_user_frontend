import 'package:flutter/foundation.dart';

class OrderRecord {
  const OrderRecord({
    required this.date,
    required this.items,
    required this.total,
    required this.status,
    this.type = 'order',
    this.imagePath,
    this.colorSeed = 0,
  });

  final String date;
  final String items;
  final double total;

  /// Either 'Pending' or 'Completed'.
  final String status;

  /// Either 'order' or 'deposit'.
  final String type;

  /// First item's asset path — null falls back to gradient placeholder.
  final String? imagePath;

  /// Controls which gradient/icon slot is used for the placeholder.
  final int colorSeed;
}

class OrderHistoryState extends ChangeNotifier {
  final List<OrderRecord> _orders = [
    const OrderRecord(
      date: 'Yesterday, 11:45 AM',
      items: 'Pork with Rice, Coconut Milk Tea',
      total: 2.75,
      status: 'Completed',
      imagePath: 'asset/foods/pork with rice.png',
      colorSeed: 1,
    ),
    const OrderRecord(
      date: 'Jun 12, 3:00 PM',
      items: 'Wallet Top-up',
      total: 5.00,
      status: 'Completed',
      type: 'deposit',
    ),
    const OrderRecord(
      date: 'Jun 10, 7:30 AM',
      items: 'Khmer Noodle',
      total: 2.00,
      status: 'Completed',
      imagePath: 'asset/foods/khmer noodle.png',
      colorSeed: 0,
    ),
    const OrderRecord(
      date: 'Jun 9, 12:00 PM',
      items: 'Chicken with Rice, Sugarcane Juice',
      total: 2.75,
      status: 'Completed',
      imagePath: 'asset/foods/chicken with rice.png',
      colorSeed: 2,
    ),
    const OrderRecord(
      date: 'Jun 7, 11:30 AM',
      items: 'Beef Lok Lak, Coconut Milk Tea',
      total: 4.00,
      status: 'Completed',
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
}
