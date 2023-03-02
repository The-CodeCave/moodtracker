enum AttestationPreference {
  /// The authenticator should not create an attestation object.
  none,

  /// The authenticator should create an attestation object if possible, but is
  /// not required to.
  indirect,

  /// The authenticator should create an attestation object.
  direct,
}

//Serialization extension
extension AttestationPreferenceExtension on AttestationPreference {
  String get value {
    switch (this) {
      case AttestationPreference.none:
        return 'none';
      case AttestationPreference.indirect:
        return 'indirect';
      case AttestationPreference.direct:
        return 'direct';
    }
  }
}
