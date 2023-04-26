enum UserVerificationPreference {
  required,
  preferred,
  discouraged,
}

//serialization extension
extension UserVerificationPreferenceExtension on UserVerificationPreference {
  String get value {
    switch (this) {
      case UserVerificationPreference.required:
        return 'required';
      case UserVerificationPreference.preferred:
        return 'preferred';
      case UserVerificationPreference.discouraged:
        return 'discouraged';
    }
  }
}
