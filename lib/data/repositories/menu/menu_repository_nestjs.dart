import 'package:dio/dio.dart';

import '../../config/api_client.dart';
import '../../config/api_config.dart';
import '../../dtos/menu_dto.dart';
import '../../exceptions/api_exception.dart';
import '../../local/token_storage.dart';
import 'menu_repository.dart';

class MenuRepositoryNestjs implements MenuRepository {
  MenuRepositoryNestjs({Dio? dio, TokenStorage? tokenStorage})
      : _dio = dio ?? createApiClient(tokenStorage: tokenStorage);

  final Dio _dio;

  @override
  Future<List<MenuItemDto>> getMenuItems({String? schoolId}) async {
    try {
      final response = await _dio.get(
        ApiConfig.menuItems,
        queryParameters: {
          'availability_status': 'available',
          'limit': 100, // fetch the full menu in one page (backend max)
          'school_id': ?schoolId,
        },
      );
      final list = response.data['data'] as List<dynamic>;
      return list
          .map((e) => MenuItemDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _mapError(e);
    } catch (e) {
      throw ApiException('Unexpected error loading menu: $e');
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
