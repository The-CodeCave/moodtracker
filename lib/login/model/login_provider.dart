enum LoginProvider {
  moodtracker,
  google,
  apple,
  applePasskey,
}

extension LoginProviderExtension on LoginProvider {
  static String defaultSignInText = 'Einloggen';
  static String googleSignIn = 'Einloggen mit Google';
  static String appleSignIn = 'Einloggen mit Apple';
  static String applePassKeySignIn = 'Einloggen mit Passkey';

  String get buttonText {
    switch (index) {
      case 1:
        return googleSignIn;
      case 2:
        return appleSignIn;
      case 3:
        return applePassKeySignIn;
      default:
        return defaultSignInText;
    }
  }
}
