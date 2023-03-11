// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:convert';
import 'dart:html' as html show window;
import 'dart:html';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_passkeys/types/authentication_response.dart';
import 'package:flutter_passkeys/types/creation_response.dart';
import 'package:flutter_passkeys/types/custom_authenticator_assertion_response.dart';
import 'package:flutter_passkeys/types/user_verification_preference.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'flutter_passkeys_platform_interface.dart';

/// A web implementation of the FlutterPasskeysPlatform of the FlutterPasskeys plugin.
class FlutterPasskeysWeb extends FlutterPasskeysPlatform {
  /// Constructs a FlutterPasskeysWeb
  FlutterPasskeysWeb();

  static void registerWith(Registrar registrar) {
    FlutterPasskeysPlatform.instance = FlutterPasskeysWeb();
  }

  /// Returns a [String] containing the version of the platform.
  @override
  Future<String?> getPlatformVersion() async {
    final version = html.window.navigator.userAgent;
    return version;
  }

  @override
  Future<AuthenticationResponse> authenticateWithPasskey({
    required String relyingParty,
    required String challenge,
    UserVerificationPreference userVerificationPreference =
        UserVerificationPreference.required,
    List<String> allowedCredentials = const [],
  }) async {
    final PublicKeyCredential result =
        await html.window.navigator.credentials!.get({
      "publicKey": {
        "rp": {
          "name": "Test",
          "id": relyingParty,
        },
        "challenge": base64Url.decode(base64Url.normalize(challenge)).buffer,
        "timeout": 60000,
        "allowCredentials": allowedCredentials
            .map((e) => {
                  "type": "public-key",
                  "id": e,
                })
            .toList(),
        "userVerification": userVerificationPreference.toString(),
      }
    });

    return AuthenticationResponse(
      userId: utf8.decode(
        (result.response as CustomAuthenticatorAssertionResponse)
            .userHandle!
            .asUint8List(),
      ),
      clientDataJSON: (result.response as AuthenticatorAssertionResponse)
          .clientDataJson!
          .asUint8List(),
      rawId: result.rawId!.asUint8List(),
      authenticatorData: (result.response as AuthenticatorAssertionResponse)
          .authenticatorData!
          .asUint8List(),
      credId: result.id!,
      response: "",
      signature: (result.response as AuthenticatorAssertionResponse)
          .signature!
          .asUint8List(),
    );
  }

  @override
  Future<CreationResponse> createPasskey({
    required String userID,
    required String displayName,
    required String relyingParty,
    required String challenge,
    UserVerificationPreference userVerificationPreference =
        UserVerificationPreference.required,
  }) async {
    final PublicKeyCredential result =
        await html.window.navigator.credentials!.create({
      "publicKey": {
        "rp": {
          "name": "Test",
          "id": relyingParty,
        },
        "user": {
          "id": Uint8List.fromList(utf8.encode(userID)).buffer,
          "name": displayName,
          "displayName": displayName,
        },
        "challenge": base64Url.decode(base64Url.normalize(challenge)).buffer,
        "pubKeyCredParams": [
          {
            "type": "public-key",
            "alg": -7,
          },
        ],
        "timeout": 60000,
        "authenticatorSelection": {
          "userVerification": userVerificationPreference.toString(),
        },
      }
    });
    return CreationResponse(
      credId: result.id!,
      rawId: result.rawId!,
      response: base64UrlEncode(result.response!.clientDataJson!.asUint8List()),
      attestation: (result.response! as AuthenticatorAttestationResponse)
          .attestationObject!
          .asUint8List(),
    );
  }
}
