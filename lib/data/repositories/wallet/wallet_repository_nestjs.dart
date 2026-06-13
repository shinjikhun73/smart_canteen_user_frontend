import '../../config/api_config.dart';
import '../../dtos/wallet_dto.dart';
import 'wallet_repository.dart';

class WalletRepositoryNestjs implements WalletRepository {
  @override
  Future<WalletBalanceDto> getBalance() {
    throw UnimplementedError('Connect ${ApiConfig.walletBalance} endpoint');
  }

  @override
  Future<WalletBalanceDto> topUp(double amountUsd) {
    throw UnimplementedError('Connect ${ApiConfig.topUp} endpoint');
  }

  @override
  Future<List<TransactionDto>> getTransactions() {
    throw UnimplementedError('Connect ${ApiConfig.transactions} endpoint');
  }
}
