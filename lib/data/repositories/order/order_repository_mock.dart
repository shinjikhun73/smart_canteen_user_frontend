import '../../dtos/order_dto.dart';
import 'order_repository.dart';

class OrderRepositoryMock implements OrderRepository {
  final List<CouponDto> _coupons = [];

  @override
  Future<PlacedOrderDto> placeOrder({
    required String schoolId,
    required String mealSession,
    required List<OrderItemInput> items,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final coupons = items
        .map((i) => CouponDto(
              id: 'mock-coupon-${DateTime.now().microsecondsSinceEpoch}-${i.menuItemId}',
              qrToken: 'mock-${DateTime.now().millisecondsSinceEpoch}-${i.menuItemId}',
              couponCode: 'MOCK123',
              mealSession: mealSession,
              status: 'active',
              validDate: DateTime.now().toIso8601String().substring(0, 10),
              menuItemName: 'Mock item',
            ))
        .toList();
    _coupons.addAll(coupons);
    return PlacedOrderDto(
      id: 'mock-order-${DateTime.now().millisecondsSinceEpoch}',
      totalAmount: 0,
      mealSession: mealSession,
      status: 'pending',
      coupons: coupons,
    );
  }

  @override
  Future<List<CouponDto>> getActiveCoupons() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _coupons.where((c) => c.isActive).toList();
  }

  @override
  Future<List<OrderSummaryDto>> getMyOrders() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return const [];
  }
}
