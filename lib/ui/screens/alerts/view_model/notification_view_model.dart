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
  final NotificationSource source;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.isRead,
    required this.createdAt,
    required this.source,
  });

  bool get isPersonal => source == NotificationSource.personal;

  NotificationItem copyWith({bool? isRead}) => NotificationItem(
        id: id,
        title: title,
        body: body,
        type: type,
        isRead: isRead ?? this.isRead,
        createdAt: createdAt,
        source: source,
      );

  factory NotificationItem.fromDto(NotificationDto dto) => NotificationItem(
        id: dto.id,
        title: dto.title,
        body: dto.body,
        type: dto.type,
        isRead: dto.isRead,
        createdAt: dto.createdAt,
        source: dto.source,
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

  // Unread count for the home-screen bell badge. Kept independent of [_state]
  // so it can be shown before the Alerts screen has ever loaded the feed.
  int _unreadBadge = 0;
  int get unreadBadge => _unreadBadge;

  /// Lightweight fetch of just the unread count — call on app landing to show
  /// the bell badge without loading the whole feed. Never throws.
  Future<void> refreshUnreadCount() async {
    try {
      _unreadBadge = await _repository.getUnreadCount();
      notifyListeners();
    } catch (_) {
      // Leave the last known count if the fetch fails.
    }
  }

  Future<void> fetchNotifications() async {
    _state = const AsyncLoading();
    notifyListeners();

    try {
      final dtos = await _repository.getNotifications();
      final items = dtos.map(NotificationItem.fromDto).toList();
      _state = AsyncData(items);
      _unreadBadge = items.where((n) => !n.isRead).length;
    } catch (e, s) {
      _state = AsyncError(e, s);
    }

    notifyListeners();
  }

  /// Marks everything read. Optimistic — flips the UI immediately, persists the
  /// personal ones on the server, and rolls back if that fails. Announcements
  /// are already shown as read, so only personal items change.
  Future<void> markAllRead() async {
    if (_state case AsyncData(data: final list)) {
      if (list.every((n) => n.isRead)) return;
      final previous = list;
      final previousBadge = _unreadBadge;
      _state = AsyncData(list.map((n) => n.copyWith(isRead: true)).toList());
      _unreadBadge = 0;
      notifyListeners();

      try {
        await _repository.markAllRead();
      } catch (_) {
        _state = AsyncData(previous);
        _unreadBadge = previousBadge;
        notifyListeners();
      }
    }
  }

  /// Removes an item. Personal notifications are deleted on the server;
  /// announcements can't be dismissed server-side, so removing one only lasts
  /// until the next fetch. Rolls back a failed server delete.
  Future<void> dismiss(NotificationItem item) async {
    if (_state case AsyncData(data: final list)) {
      final previous = list;
      final previousBadge = _unreadBadge;
      _state = AsyncData(list.where((n) => n.id != item.id).toList());
      if (item.isPersonal && !item.isRead && _unreadBadge > 0) _unreadBadge--;
      notifyListeners();

      if (item.isPersonal) {
        try {
          await _repository.dismiss(item.id);
        } catch (_) {
          _state = AsyncData(previous);
          _unreadBadge = previousBadge;
          notifyListeners();
        }
      }
    }
  }
}
