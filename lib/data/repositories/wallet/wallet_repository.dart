import '../../dtos/wallet_dto.dart';

abstract class WalletRepository {
  Future<WalletBalanceDto> getBalance();
  Future<WalletBalanceDto> topUp(double amountUsd);
  Future<WalletBalanceDto> payment(double amountUsd);
  Future<List<TransactionDto>> getTransactions();
}
