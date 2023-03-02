
import 'package:flutter_passkeys/types/authentication_response.dart';
import 'package:flutter_passkeys/types/creation_response.dart';
import 'package:flutter_passkeys/types/user_verification_preference.dart';
import 'flutter_passkeys_platform_interface.dart';

class FlutterPasskeys {
  Future<String?> getPlatformVersion() {
    return FlutterPasskeysPlatform.instance.getPlatformVersion();
  }

  Future<CreationResponse> createPasskey({
    required String userID,
    required String displayName,
    required String relyingParty,
    required String challenge,
    UserVerificationPreference userVerificationPreference =
        UserVerificationPreference.required,
  }) {
    return FlutterPasskeysPlatform.instance.createPasskey(
      userID: userID,
      displayName: displayName,
      relyingParty: relyingParty,
      challenge: challenge,
      userVerificationPreference: userVerificationPreference,
    );
  }

  Future<AuthenticationResponse> authenticateWithPasskey({
    required String relyingParty,
    required String challenge,
    UserVerificationPreference userVerificationPreference =
        UserVerificationPreference.required,
    List<String> allowedCredentials = const [],
  }) {
    return FlutterPasskeysPlatform.instance.authenticateWithPasskey(
      relyingParty: relyingParty,
      challenge: challenge,
      userVerificationPreference: userVerificationPreference,
      allowedCredentials: allowedCredentials,
    );
  }
}
