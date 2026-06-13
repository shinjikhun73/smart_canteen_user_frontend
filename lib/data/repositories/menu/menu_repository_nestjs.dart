import '../../config/api_config.dart';
import '../../dtos/menu_dto.dart';
import 'menu_repository.dart';

class MenuRepositoryNestjs implements MenuRepository {
  @override
  Future<List<MenuItemDto>> getWeeklyMenu() {
    throw UnimplementedError('Connect ${ApiConfig.weeklyMenu} endpoint');
  }

  @override
  Future<List<MenuItemDto>> getMenuBySession(String session) {
    throw UnimplementedError('Connect ${ApiConfig.menuBySession}?session=$session endpoint');
  }
}
