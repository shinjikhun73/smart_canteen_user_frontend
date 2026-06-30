import 'package:flutter/foundation.dart';

/// User-controllable notification preferences shown in Settings → Notifications.
class NotificationPrefsState extends ChangeNotifier {
  bool _orderUpdates = true;
  bool _promotions = false;
  bool _systemAlerts = true;

  bool get orderUpdates => _orderUpdates;
  bool get promotions => _promotions;
  bool get systemAlerts => _systemAlerts;

  void setOrderUpdates(bool value) {
    _orderUpdates = value;
    notifyListeners();
  }

  void setPromotions(bool value) {
    _promotions = value;
    notifyListeners();
  }

  void setSystemAlerts(bool value) {
    _systemAlerts = value;
    notifyListeners();
  }
}
