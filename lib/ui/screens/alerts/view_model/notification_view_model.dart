import 'package:flutter/foundation.dart';

import '../../../../data/dtos/notification_dto.dart';
import '../../../utils/async_value.dart';

class NotificationItem {
  final String id;
  final String title;
  final String body;
  final String type;
  final bool isRead;
  final DateTime createdAt;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.isRead,
    required this.createdAt,
  });

  NotificationItem copyWith({bool? isRead}) => NotificationItem(
        id: id,
        title: title,
        body: body,
        type: type,
        isRead: isRead ?? this.isRead,
        createdAt: createdAt,
      );

  factory NotificationItem.fromDto(NotificationDto dto) => NotificationItem(
        id: dto.id,
        title: dto.title,
        body: dto.body,
        type: dto.type,
        isRead: dto.isRead,
        createdAt: dto.createdAt,
      );
}

class NotificationViewModel extends ChangeNotifier {
  AsyncValue<List<NotificationItem>> _state = const AsyncLoading();

  AsyncValue<List<NotificationItem>> get state => _state;

  int get unreadCount => switch (_state) {
        AsyncData(data: final list) => list.where((n) => !n.isRead).length,
        _ => 0,
      };

  Future<void> fetchNotifications() async {
    _state = const AsyncLoading();
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 600));
      _state = AsyncData(_mockItems());
    } catch (e, s) {
      _state = AsyncError(e, s);
    }

    notifyListeners();
  }

  void markAllRead() {
    if (_state case AsyncData(data: final list)) {
      _state = AsyncData(list.map((n) => n.copyWith(isRead: true)).toList());
      notifyListeners();
    }
  }

  void dismiss(String id) {
    if (_state case AsyncData(data: final list)) {
      _state = AsyncData(list.where((n) => n.id != id).toList());
      notifyListeners();
    }
  }

  List<NotificationItem> _mockItems() => [
        NotificationItem(id: 'n1', title: 'Balance Low', body: 'Your wallet balance is below \$5. Top up to continue ordering.', type: 'balance', isRead: false, createdAt: DateTime.now().subtract(const Duration(minutes: 10))),
        NotificationItem(id: 'n2', title: 'Scholar Discount Active', body: '20% off all meals this week for CADT Scholars.', type: 'promo', isRead: false, createdAt: DateTime.now().subtract(const Duration(hours: 2))),
        NotificationItem(id: 'n3', title: 'Coupon Redeemed', body: 'Breakfast coupon used successfully at 7:45 AM.', type: 'coupon', isRead: true, createdAt: DateTime.now().subtract(const Duration(hours: 5))),
        NotificationItem(id: 'n4', title: 'Top-Up Confirmed', body: '\$10.00 added to your wallet successfully.', type: 'balance', isRead: true, createdAt: DateTime.now().subtract(const Duration(days: 1))),
      ];
}
