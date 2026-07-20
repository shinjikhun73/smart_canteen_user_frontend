import 'package:dio/dio.dart';

import '../../config/api_client.dart';
import '../../config/api_config.dart';
import '../../dtos/notification_dto.dart';
import '../../exceptions/api_exception.dart';
import '../../local/token_storage.dart';
import 'notification_repository.dart';

/// Talks to the NestJS announcements feed. The app has no per-user notification
/// store yet, so the Alerts screen shows the published announcements broadcast
/// (`GET /announcements?status=published`) mapped onto the app's notification
/// shape. There's no read/dismiss state on the backend, so every item comes
/// back unread; read/dismiss are handled client-side by the view model.
class NotificationRepositoryNestjs implements NotificationRepository {
  NotificationRepositoryNestjs({Dio? dio, TokenStorage? tokenStorage})
      : _dio = dio ?? createApiClient(tokenStorage: tokenStorage);

  final Dio _dio;

  @override
  Future<List<NotificationDto>> getNotifications() async {
    try {
      final response = await _dio.get(
        ApiConfig.announcements,
        queryParameters: {
          'status': 'published',
          'limit': 50,
        },
      );
      final list = response.data['data'] as List<dynamic>;
      return list
          .map((e) => _fromAnnouncement(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _mapError(e);
    } catch (e) {
      throw ApiException('Unexpected error loading notifications: $e');
    }
  }

  /// Maps a backend `Announcement` onto the app's [NotificationDto]. The feed is
  /// a broadcast with no notification `type` or read state, so `type` is
  /// synthesized as `announcement` (renders the default bell icon) and
  /// `isRead` defaults to false.
  NotificationDto _fromAnnouncement(Map<String, dynamic> json) => NotificationDto(
        id: json['id'] as String,
        title: json['title'] as String,
        body: (json['content'] as String?) ?? '',
        type: 'announcement',
        isRead: false,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

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
