import 'dart:convert';

import 'package:dio/dio.dart';

import '../../config/api_client.dart';
import '../../config/api_config.dart';
import '../../dtos/order_dto.dart';
import '../../exceptions/api_exception.dart';
import '../../local/token_storage.dart';
import 'order_repository.dart';

class OrderRepositoryNestjs implements OrderRepository {
  OrderRepositoryNestjs({Dio? dio, TokenStorage? tokenStorage})
      : _tokenStorage = tokenStorage ?? TokenStorage.instance,
        _dio = dio ?? createApiClient(tokenStorage: tokenStorage);

  final Dio _dio;
  final TokenStorage _tokenStorage;

  @override
  Future<PlacedOrderDto> placeOrder({
    required String schoolId,
    required String mealSession,
    required List<OrderItemInput> items,
  }) async {
    try {
      final response = await _dio.post(ApiConfig.orders, data: {
        'school_id': schoolId,
        'meal_session': mealSession,
        'items': items.map((i) => i.toJson()).toList(),
      });
      return PlacedOrderDto.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw _mapError(e);
    } catch (e) {
      throw ApiException('Unexpected error placing order: $e');
    }
  }

  @override
  Future<List<CouponDto>> getActiveCoupons() async {
    final userId = await _currentUserId();
    if (userId == null) {
      throw const ApiException('Not signed in — cannot load coupons.');
    }
    try {
      final response = await _dio.get(
        ApiConfig.coupons,
        queryParameters: {
          'user_id': userId,
          'status': 'active',
          'limit': 100,
        },
      );
      final list = response.data['data'] as List<dynamic>;
      return list
          .map((e) => CouponDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _mapError(e);
    } catch (e) {
      throw ApiException('Unexpected error loading coupons: $e');
    }
  }

  @override
  Future<List<OrderSummaryDto>> getMyOrders() async {
    try {
      final response = await _dio.get(
        ApiConfig.ordersMy,
        queryParameters: {'limit': 100},
      );
      final list = response.data['data'] as List<dynamic>;
      return list
          .map((e) => OrderSummaryDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _mapError(e);
    } catch (e) {
      throw ApiException('Unexpected error loading orders: $e');
    }
  }

  /// Reads the user id (`sub`) from the stored JWT access token, without a
  /// network round-trip.
  Future<String?> _currentUserId() async {
    final token = await _tokenStorage.readAccessToken();
    if (token == null) return null;
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      final payload = utf8.decode(
        base64Url.decode(base64Url.normalize(parts[1])),
      );
      final map = jsonDecode(payload) as Map<String, dynamic>;
      return map['sub'] as String?;
    } catch (_) {
      return null;
    }
  }

  ApiException _mapError(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      final errors = data['errors'];
      if (errors is List && errors.isNotEmpty) {
        return ApiException(errors.join('\n'), statusCode: e.response?.statusCode);
      }
      final message = data['message'];
      if (message is String) {
        return ApiException(message, statusCode: e.response?.statusCode);
      }
      if (message is List && message.isNotEmpty) {
        return ApiException(message.join('\n'), statusCode: e.response?.statusCode);
      }
    }
    return ApiException('${e.type.name}: ${e.message ?? e.error ?? e}');
  }
}
