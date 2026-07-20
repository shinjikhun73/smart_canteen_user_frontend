import '../../dtos/notification_dto.dart';
import 'notification_repository.dart';

class NotificationRepositoryMock implements NotificationRepository {
  @override
  Future<List<NotificationDto>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 600));
    final now = DateTime.now();
    return [
      NotificationDto(
        id: 'n1',
        title: 'Balance Low',
        body: 'Your wallet balance is below \$5. Top up to continue ordering.',
        type: 'balance',
        isRead: false,
        createdAt: now.subtract(const Duration(minutes: 10)),
      ),
      NotificationDto(
        id: 'n2',
        title: 'Scholar Discount Active',
        body: '20% off all meals this week for CADT Scholars.',
        type: 'promo',
        isRead: false,
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      NotificationDto(
        id: 'n3',
        title: 'Coupon Redeemed',
        body: 'Breakfast coupon used successfully at 7:45 AM.',
        type: 'coupon',
        isRead: true,
        createdAt: now.subtract(const Duration(hours: 5)),
      ),
      NotificationDto(
        id: 'n4',
        title: 'Top-Up Confirmed',
        body: '\$10.00 added to your wallet successfully.',
        type: 'balance',
        isRead: true,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
    ];
  }
}
