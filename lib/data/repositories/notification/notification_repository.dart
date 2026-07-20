import '../../dtos/notification_dto.dart';

abstract class NotificationRepository {
  /// The merged Alerts feed: the user's own event notifications plus published
  /// announcements, newest first.
  Future<List<NotificationDto>> getNotifications();

  /// Number of unread personal notifications (for the bell badge).
  Future<int> getUnreadCount();

  /// Marks all of the user's personal notifications as read on the server.
  Future<void> markAllRead();

  /// Dismisses (deletes) a single personal notification on the server. Only
  /// personal notifications can be dismissed — announcements are broadcast.
  Future<void> dismiss(String id);
}
