import 'package:flutter/foundation.dart';

import '../../../../data/repositories/menu/menu_repository.dart';
import '../../../../model/meal/meal_item.dart';
import '../../../utils/async_value.dart';

class MenuViewModel extends ChangeNotifier {
  final MenuRepository _menuRepository;

  AsyncValue<List<MealItem>> _menuState = const AsyncLoading();
  String _selectedSession = '';

  MenuViewModel(this._menuRepository);

  AsyncValue<List<MealItem>> get menuState => _menuState;
  String get selectedSession => _selectedSession;

  List<MealItem> get filteredItems => switch (_menuState) {
        AsyncData(data: final list) when _selectedSession.isEmpty => list,
        AsyncData(data: final list) =>
          list.where((m) => m.session.name == _selectedSession).toList(),
        _ => [],
      };

  Future<void> fetchWeeklyMenu() async {
    _menuState = const AsyncLoading();
    notifyListeners();

    try {
      final dtos = await _menuRepository.getWeeklyMenu();
      _menuState = AsyncData(
        dtos.asMap().entries.map((e) => MealItem.fromDto(e.value, colorSeed: e.key)).toList(),
      );
    } catch (e, s) {
      _menuState = AsyncError(e, s);
    }

    notifyListeners();
  }

  void setSession(String session) {
    if (_selectedSession == session) return;
    _selectedSession = session;
    notifyListeners();
  }
}
