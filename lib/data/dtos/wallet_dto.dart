class WalletBalanceDto {
  final String walletId;
  final double balanceKhr;
  final double balanceUsd;
  final bool isActive;

  const WalletBalanceDto({
    required this.walletId,
    required this.balanceKhr,
    required this.balanceUsd,
    required this.isActive,
  });

  factory WalletBalanceDto.fromJson(Map<String, dynamic> json) => WalletBalanceDto(
        walletId: json['wallet_id'] as String,
        balanceKhr: (json['balance_khr'] as num).toDouble(),
        balanceUsd: (json['balance_usd'] as num).toDouble(),
        isActive: json['is_active'] as bool,
      );
}

class TransactionDto {
  final String id;
  final String type; // 'topup' | 'purchase' | 'refund'
  final double amountUsd;
  final String description;
  final DateTime createdAt;

  const TransactionDto({
    required this.id,
    required this.type,
    required this.amountUsd,
    required this.description,
    required this.createdAt,
  });

  factory TransactionDto.fromJson(Map<String, dynamic> json) => TransactionDto(
        id: json['id'] as String,
        type: json['type'] as String,
        amountUsd: (json['amount_usd'] as num).toDouble(),
        description: json['description'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
      );
}
