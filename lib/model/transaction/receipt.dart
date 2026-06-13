import '../../data/dtos/wallet_dto.dart';

class Receipt {
  final String id;
  final TransactionType type;
  final double amountUsd;
  final String description;
  final DateTime createdAt;

  const Receipt({
    required this.id,
    required this.type,
    required this.amountUsd,
    required this.description,
    required this.createdAt,
  });

  factory Receipt.fromDto(TransactionDto dto) => Receipt(
        id: dto.id,
        type: TransactionType.fromString(dto.type),
        amountUsd: dto.amountUsd,
        description: dto.description,
        createdAt: dto.createdAt,
      );

  String get formattedAmount {
    final prefix = type == TransactionType.topup ? '+' : '-';
    return '$prefix\$${amountUsd.toStringAsFixed(2)}';
  }
}

enum TransactionType {
  topup,
  purchase,
  refund;

  static TransactionType fromString(String value) => switch (value) {
        'purchase' => TransactionType.purchase,
        'refund' => TransactionType.refund,
        _ => TransactionType.topup,
      };

  String get label => switch (this) {
        TransactionType.topup => 'Top Up',
        TransactionType.purchase => 'Purchase',
        TransactionType.refund => 'Refund',
      };
}
