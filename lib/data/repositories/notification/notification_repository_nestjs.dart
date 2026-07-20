import 'package:dio/dio.dart';

import '../../config/api_client.dart';
import '../../config/api_config.dart';
import '../../dtos/notification_dto.dart';
import '../../exceptions/api_exception.dart';
import '../../local/token_storage.dart';
import 'notification_repository.dart';

/// Backs the Alerts screen with a merged feed:
///  - the signed-in user's own event notifications (`GET /notifications`), and
///  - published admin announcements (`GET /announcements?status=published`).
/// The two are fetched together and merged newest-first. Read/dismiss operate
/// only on personal notifications; announcements are broadcast and read-only.
class NotificationRepositoryNestjs implements NotificationRepository {
  NotificationRepositoryNestjs({Dio? dio, TokenStorage? tokenStorage})
      : _dio = dio ?? createApiClient(tokenStorage: tokenStorage);

  final Dio _dio;

  @override
  Future<List<NotificationDto>> getNotifications() async {
    try {
      final results = await Future.wait([
        _fetchPersonal(),
        _fetchAnnouncements(),
      ]);
      final merged = [...results[0], ...results[1]]
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return merged;
    } on DioException catch (e) {
      throw _mapError(e);
    } catch (e) {
      throw ApiException('Unexpected error loading notifications: $e');
    }
  }

  Future<List<NotificationDto>> _fetchPersonal() async {
    final response = await _dio.get(
      ApiConfig.notifications,
      queryParameters: {'limit': 50},
    );
    final list = response.data['data'] as List<dynamic>;
    return list
        .map((e) => NotificationDto.fromNotification(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<NotificationDto>> _fetchAnnouncements() async {
    final response = await _dio.get(
      ApiConfig.announcements,
      queryParameters: {'status': 'published', 'limit': 50},
    );
    final list = response.data['data'] as List<dynamic>;
    return list
        .map((e) => NotificationDto.fromAnnouncement(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<int> getUnreadCount() async {
    try {
      final response = await _dio.get(ApiConfig.notificationsUnreadCount);
      return (response.data['data']['count'] as num?)?.toInt() ?? 0;
    } on DioException catch (e) {
      throw _mapError(e);
    } catch (e) {
      throw ApiException('Unexpected error loading unread count: $e');
    }
  }

  @override
  Future<void> markAllRead() async {
    try {
      await _dio.patch(ApiConfig.notificationsReadAll);
    } on DioException catch (e) {
      throw _mapError(e);
    } catch (e) {
      throw ApiException('Unexpected error marking notifications read: $e');
    }
  }

  @override
  Future<void> dismiss(String id) async {
    try {
      await _dio.delete(ApiConfig.notificationById(id));
    } on DioException catch (e) {
      throw _mapError(e);
    } catch (e) {
      throw ApiException('Unexpected error dismissing notification: $e');
    }
  }

  ApiException _mapError(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String) {
        return ApiException(message, statusCode: e.response?.statusCode);
      }
    }
    return ApiException('${e.type.name}: ${e.message ?? e.error ?? e}');
  }
}
