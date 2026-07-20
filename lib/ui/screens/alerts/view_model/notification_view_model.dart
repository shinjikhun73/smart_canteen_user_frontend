import 'package:flutter/foundation.dart';

import '../../../../data/dtos/notification_dto.dart';
import '../../../../data/repositories/notification/notification_repository.dart';
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
  NotificationViewModel(this._repository);

  final NotificationRepository _repository;

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
      final dtos = await _repository.getNotifications();
      _state = AsyncData(dtos.map(NotificationItem.fromDto).toList());
    } catch (e, s) {
      _state = AsyncError(e, s);
    }

    notifyListeners();
  }

  // Read/dismiss are client-side only — the announcements feed has no per-user
  // read state on the backend, so these reset on the next fetch.
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
}
