import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_passkeys/types/attestation_preference.dart';
import 'package:flutter_passkeys/types/authentication_response.dart';
import 'package:flutter_passkeys/types/creation_response.dart';
import 'package:flutter_passkeys/types/user_verification_preference.dart';

import 'flutter_passkeys_platform_interface.dart';

/// An implementation of [FlutterPasskeysPlatform] that uses method channels.
class MethodChannelFlutterPasskeys extends FlutterPasskeysPlatform {
  /// The method channel used to interact with the native platform.

  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_passkeys');

  Completer? activeRequest;

  MethodChannelFlutterPasskeys() {
    methodChannel.setMethodCallHandler(_handleMethodCall);
  }

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');

    return version;
  }

  @override
  Future<CreationResponse> createPasskey({
    required String userID,
    required String displayName,
    required String relyingParty,
    required String challenge,
    UserVerificationPreference userVerificationPreference =
        UserVerificationPreference.required,
    AttestationPreference attestationPreference = AttestationPreference.direct,
  }) async {
    activeRequest = Completer<CreationResponse>();
    methodChannel.invokeMethod<String>(
      'create_passkey',
      {
        'userID': userID,
        'displayName': displayName,
        'relyingParty': relyingParty,
        'challenge': challenge,
        "userVerificationPreference": userVerificationPreference.value,
        "attestationPreference": attestationPreference.value,
      },
    ).then((value) => {
          print(value),
        });
    return activeRequest!.future as Future<CreationResponse>;
  }

  @override
  Future<AuthenticationResponse> authenticateWithPasskey({
    required String relyingParty,
    required String challenge,
    UserVerificationPreference userVerificationPreference =
        UserVerificationPreference.required,
    List<String> allowedCredentials = const [],
  }) async {
    activeRequest = Completer<AuthenticationResponse>();
    methodChannel.invokeMethod<String>(
      'assert_passkey',
      {
        'relyingParty': relyingParty,
        'challenge': challenge,
        "allowedCredentials": allowedCredentials,
        "userVerificationPreference": userVerificationPreference.value,
      },
    ).then((value) => {
          print(value),
        });
    return activeRequest!.future as Future<AuthenticationResponse>;
  }

  Future _handleMethodCall(MethodCall call) async {
    if (call.method == "passkey_create_complete") {
      activeRequest!.complete(
          CreationResponse.fromMap(Map<String, dynamic>.from(call.arguments)));
    }
    if (call.method == "passkey_auth_complete") {
      final mapped = AuthenticationResponse.fromMap(
          Map<String, dynamic>.from(call.arguments));
      activeRequest!.complete(mapped);
    }
    if (call.method == "passkey_auth_failed") {
      activeRequest!.completeError(call.arguments);
    }
    return;
  }
}
