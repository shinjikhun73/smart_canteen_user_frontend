import '../../dtos/menu_dto.dart';

abstract class MenuRepository {
  /// Fetches available menu items. When [schoolId] is given, results are scoped
  /// to that school; otherwise the backend returns items across all schools.
  Future<List<MenuItemDto>> getMenuItems({String? schoolId});
}
