class NotificationDto {
  final String id;
  final String title;
  final String body;
  final String type; // 'balance' | 'promo' | 'system' | 'coupon'
  final bool isRead;
  final DateTime createdAt;

  const NotificationDto({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationDto.fromJson(Map<String, dynamic> json) => NotificationDto(
        id: json['id'] as String,
        title: json['title'] as String,
        body: json['body'] as String,
        type: json['type'] as String,
        isRead: json['is_read'] as bool,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'type': type,
        'is_read': isRead,
        'created_at': createdAt.toIso8601String(),
      };
}
