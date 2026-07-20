import '../../dtos/notification_dto.dart';

abstract class NotificationRepository {
  /// Loads the notifications shown in the Alerts screen. Currently backed by
  /// the backend's published announcements broadcast feed.
  Future<List<NotificationDto>> getNotifications();
}
