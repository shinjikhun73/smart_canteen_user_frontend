import 'dart:io';

import 'package:flutter/foundation.dart';

/// Holds the signed-in user's editable profile so the header, stats,
/// and Edit Profile form all stay in sync.
class UserProfileState extends ChangeNotifier {
  String? _userId;
  String _name = 'John Doe';
  String _email = 'john.doe@cadt.edu.kh';
  String _badge = 'CADT Scholar';
  File? _photo;

  /// False for Google-only accounts (no password set). Drives the
  /// "Set a password" option in Settings.
  bool _canUseEmailPassword = true;
  bool get canUseEmailPassword => _canUseEmailPassword;

  /// Backend id of the signed-in user, needed to `PATCH /users/:id/profile`.
  /// Null until the profile is loaded from the backend.
  String? get userId => _userId;
  String get name => _name;
  String get email => _email;
  String get badge => _badge;
  File? get photo => _photo;

  /// Fills the profile from the signed-in backend user (id, name, email, school).
  /// Empty values are ignored so we never blank the header.
  void setFromUser({
    required String id,
    required String name,
    required String email,
    String? schoolName,
    bool canUseEmailPassword = true,
  }) {
    _canUseEmailPassword = canUseEmailPassword;
    if (id.trim().isNotEmpty) _userId = id.trim();
    if (name.trim().isNotEmpty) _name = name.trim();
    if (email.trim().isNotEmpty) _email = email.trim();
    if (schoolName != null && schoolName.trim().isNotEmpty) {
      _badge = schoolName.trim();
    }
    notifyListeners();
  }

  /// Two-letter initials derived from the name, e.g. "John Doe" → "JD".
  String get initials {
    final parts = _name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  void updateProfile({required String name, required String email}) {
    _name = name.trim();
    _email = email.trim();
    notifyListeners();
  }

  /// Called after a password is successfully set, so the "Set a password"
  /// option disappears without needing a full profile reload.
  void markPasswordSet() {
    if (_canUseEmailPassword) return;
    _canUseEmailPassword = true;
    notifyListeners();
  }

  void setPhoto(File? photo) {
    _photo = photo;
    notifyListeners();
  }
}
