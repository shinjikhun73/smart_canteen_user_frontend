import '../../dtos/order_dto.dart';

abstract class OrderRepository {
  /// Places an order (backend deducts stock and mints a QR coupon per item),
  /// returning the order with its coupons. Does NOT charge the wallet — pay
  /// separately via the wallet repository using [PlacedOrderDto.totalAmount].
  Future<PlacedOrderDto> placeOrder({
    required String schoolId,
    required String mealSession,
    required List<OrderItemInput> items,
  });

  /// The signed-in user's currently active (unredeemed) coupons.
  Future<List<CouponDto>> getActiveCoupons();

  /// The signed-in user's past orders (most recent first).
  Future<List<OrderSummaryDto>> getMyOrders();
}
