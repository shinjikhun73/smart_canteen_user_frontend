import '../../dtos/menu_dto.dart';

abstract class MenuRepository {
  Future<List<MenuItemDto>> getWeeklyMenu();
  Future<List<MenuItemDto>> getMenuBySession(String session);
}
