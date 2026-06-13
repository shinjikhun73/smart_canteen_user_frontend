import '../../config/api_config.dart';
import '../../dtos/coupon_dto.dart';
import 'coupon_repository.dart';

class CouponRepositoryNestjs implements CouponRepository {
  @override
  Future<List<CouponPlanDto>> getPlans() {
    throw UnimplementedError('Connect ${ApiConfig.couponPlans} endpoint');
  }

  @override
  Future<ActiveCouponDto> purchasePlan(String planId) {
    throw UnimplementedError('Connect ${ApiConfig.purchaseCoupon} endpoint');
  }

  @override
  Future<List<ActiveCouponDto>> getActiveCoupons() {
    throw UnimplementedError('Connect ${ApiConfig.orderHistory} endpoint');
  }
}
