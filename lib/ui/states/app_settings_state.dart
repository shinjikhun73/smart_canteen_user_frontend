import 'package:flutter/foundation.dart';

enum AppBranch { cadt, itc, mptc }

class AppSettingsState extends ChangeNotifier {
  bool _isDarkMode = false;
  AppBranch _branch = AppBranch.cadt;

  bool get isDarkMode => _isDarkMode;
  AppBranch get branch => _branch;

  String get branchLabel => switch (_branch) {
        AppBranch.cadt => 'CADT',
        AppBranch.itc => 'ITC',
        AppBranch.mptc => 'MPTC',
      };

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setBranch(AppBranch branch) {
    if (_branch == branch) return;
    _branch = branch;
    notifyListeners();
  }
}
