class GoogleAuthConfig {
  GoogleAuthConfig._();

  /// The backend's Google OAuth "Web application" client ID (see backend
  /// `.env` -> GOOGLE_CLIENT_ID). This is not a secret — Google's own docs
  /// have you embed client IDs directly in mobile app code — but it must be
  /// passed as `serverClientId` so the ID token this app receives has an
  /// audience the backend can verify.
  static const String serverClientId =
      '421411286734-o2vl2ian1leq2mo1css8u411d1am1etc.apps.googleusercontent.com';

  /// The iOS OAuth client ID (type: iOS) from Google Cloud Console. Used only
  /// on iOS to identify the app to Google; the resulting ID token's audience
  /// is still [serverClientId], which is what the backend verifies.
  ///
  /// The reversed form of this ID must also be registered as a URL scheme in
  /// `ios/Runner/Info.plist` so Google can hand the OAuth result back to the app.
  static const String iosClientId =
      '421411286734-i0r7db6pd4ijhcgugquadfnkdnca1dfu.apps.googleusercontent.com';
}
