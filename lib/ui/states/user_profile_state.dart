import 'dart:io';

import 'package:flutter/foundation.dart';

/// Holds the signed-in user's editable profile so the header, stats,
/// and Edit Profile form all stay in sync.
class UserProfileState extends ChangeNotifier {
  String _name = 'John Doe';
  String _email = 'john.doe@cadt.edu.kh';
  final String _badge = 'CADT Scholar';
  File? _photo;

  String get name => _name;
  String get email => _email;
  String get badge => _badge;
  File? get photo => _photo;

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

  void setPhoto(File? photo) {
    _photo = photo;
    notifyListeners();
  }
}
