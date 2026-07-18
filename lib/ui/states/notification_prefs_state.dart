import 'package:flutter/foundation.dart';

import '../../data/repositories/auth/auth_repository.dart';

/// User-controllable notification preferences shown in Settings → Notifications.
///
/// Hydrated from the signed-in user (`GET /users/me`) and persisted to the
/// backend (`PATCH /users/:id/notification-preferences`) on every toggle.
/// Updates are optimistic: the switch flips immediately and rolls back if the
/// request fails.
class NotificationPrefsState extends ChangeNotifier {
  NotificationPrefsState(this._authRepository);

  final AuthRepository _authRepository;

  String? _userId;
  bool _orderUpdates = true;
  bool _promotions = false;
  bool _systemAlerts = true;
  bool _saving = false;

  bool get orderUpdates => _orderUpdates;
  bool get promotions => _promotions;
  bool get systemAlerts => _systemAlerts;

  /// True while a toggle is being persisted.
  bool get isSaving => _saving;

  /// Fills the preferences from the signed-in backend user. Call after loading
  /// the profile (splash auto-login and the home screen both do this).
  void setFromUser({
    required String userId,
    required bool orderUpdates,
    required bool promotions,
    required bool systemAlerts,
  }) {
    _userId = userId;
    _orderUpdates = orderUpdates;
    _promotions = promotions;
    _systemAlerts = systemAlerts;
    notifyListeners();
  }

  /// Returns true once the change is saved, false if it failed (and was rolled
  /// back). The caller can surface an error when false.
  Future<bool> setOrderUpdates(bool value) => _persist(orderUpdates: value);
  Future<bool> setPromotions(bool value) => _persist(promotions: value);
  Future<bool> setSystemAlerts(bool value) => _persist(systemAlerts: value);

  Future<bool> _persist({
    bool? orderUpdates,
    bool? promotions,
    bool? systemAlerts,
  }) async {
    final userId = _userId;
    if (userId == null) return false;

    // Snapshot for rollback, then apply optimistically.
    final prevOrderUpdates = _orderUpdates;
    final prevPromotions = _promotions;
    final prevSystemAlerts = _systemAlerts;
    if (orderUpdates != null) _orderUpdates = orderUpdates;
    if (promotions != null) _promotions = promotions;
    if (systemAlerts != null) _systemAlerts = systemAlerts;
    _saving = true;
    notifyListeners();

    try {
      final prefs = await _authRepository.updateNotificationPreferences(
        userId: userId,
        orderUpdates: orderUpdates,
        promotions: promotions,
        systemAlerts: systemAlerts,
      );
      _orderUpdates = prefs.orderUpdates;
      _promotions = prefs.promotions;
      _systemAlerts = prefs.systemAlerts;
      _saving = false;
      notifyListeners();
      return true;
    } catch (_) {
      _orderUpdates = prevOrderUpdates;
      _promotions = prevPromotions;
      _systemAlerts = prevSystemAlerts;
      _saving = false;
      notifyListeners();
      return false;
    }
  }
}
