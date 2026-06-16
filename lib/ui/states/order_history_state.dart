import 'package:flutter/foundation.dart';

class OrderRecord {
  const OrderRecord({
    required this.date,
    required this.items,
    required this.total,
    required this.status,
  });

  final String date;
  final String items;
  final double total;

  /// Either 'Pending' or 'Completed'.
  final String status;
}

class OrderHistoryState extends ChangeNotifier {
  final List<OrderRecord> _orders = [
    const OrderRecord(
      date: 'Yesterday, 11:45 AM',
      items: 'Pork with Rice, Coconut Milk Tea',
      total: 2.75,
      status: 'Completed',
    ),
    const OrderRecord(
      date: 'Jun 10, 7:30 AM',
      items: 'Khmer Noodle',
      total: 2.00,
      status: 'Completed',
    ),
    const OrderRecord(
      date: 'Jun 9, 12:00 PM',
      items: 'Chicken with Rice, Sugarcane Juice',
      total: 2.75,
      status: 'Completed',
    ),
    const OrderRecord(
      date: 'Jun 8, 7:15 AM',
      items: 'Bai Sach Chrouk',
      total: 1.50,
      status: 'Completed',
    ),
    const OrderRecord(
      date: 'Jun 7, 11:30 AM',
      items: 'Beef Lok Lak, Coconut Milk Tea',
      total: 4.00,
      status: 'Completed',
    ),
  ];

  List<OrderRecord> get orders => List.unmodifiable(_orders);

  /// Inserts a new order at the top of the list.
  void addOrder(OrderRecord order) {
    _orders.insert(0, order);
    notifyListeners();
  }
}
