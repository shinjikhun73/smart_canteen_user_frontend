import 'package:flutter/foundation.dart';

import '../../data/dtos/menu_dto.dart';
import '../../data/repositories/menu/menu_repository.dart';
import '../../models/food_item.dart';
import '../utils/async_value.dart';

/// Loads the backend menu once and exposes it as [FoodItem]s so the existing
/// menu UI (and the cart) work unchanged. The backend has no images/ratings, so
/// items render with the card's gradient + icon placeholders.
class MenuState extends ChangeNotifier {
  final MenuRepository _menuRepository;

  MenuState(this._menuRepository);

  AsyncValue<List<FoodItem>> _items = const AsyncLoading();
  AsyncValue<List<FoodItem>> get items => _items;

  /// The school the loaded menu belongs to — used to scope a placed order to
  /// the correct tenant. Captured from the fetched items.
  String? _schoolId;
  String? get schoolId => _schoolId;

  bool _hasLoaded = false;

  /// Loads the menu. No-ops once loaded unless [force] is set.
  Future<void> load({String? schoolId, bool force = false}) async {
    if (_hasLoaded && !force && _items is AsyncData<List<FoodItem>>) return;

    _items = const AsyncLoading();
    notifyListeners();

    try {
      final dtos = await _menuRepository.getMenuItems(schoolId: schoolId);
      _schoolId = dtos.isNotEmpty ? dtos.first.schoolId : null;
      final foods = dtos
          .asMap()
          .entries
          .map((e) => _toFoodItem(e.value, e.key))
          .toList();
      _items = AsyncData(foods);
      _hasLoaded = true;
    } catch (e, s) {
      _items = AsyncError(e, s);
    }

    notifyListeners();
  }

  FoodItem _toFoodItem(MenuItemDto dto, int index) => FoodItem(
        id: dto.id,
        name: dto.name,
        description: dto.description,
        price: dto.price,
        rating: 0.0, // backend has no ratings
        tags: dto.categoryName != null ? [dto.categoryName!] : const <String>[],
        category: (dto.categoryName ?? 'other').toLowerCase(),
        imagePath: null,
        // TEMP: one shared photo for every dish (backend has no per-item image
        // yet). When MenuItemDto gains a real image_url, use dto.imageUrl here.
        imageUrl: kTestFoodImageUrl,
        colorSeed: index,
      );
}
