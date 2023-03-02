
import 'package:flutter_passkeys/types/authentication_response.dart';
import 'package:flutter_passkeys/types/creation_response.dart';
import 'package:flutter_passkeys/types/user_verification_preference.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_passkeys_method_channel.dart';

abstract class FlutterPasskeysPlatform extends PlatformInterface {
  /// Constructs a FlutterPasskeysPlatform.
  FlutterPasskeysPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterPasskeysPlatform _instance = MethodChannelFlutterPasskeys();

  /// The default instance of [FlutterPasskeysPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterPasskeys].
  static FlutterPasskeysPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterPasskeysPlatform] when
  /// they register themselves.
  static set instance(FlutterPasskeysPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<CreationResponse> createPasskey({
    required String userID,
    required String displayName,
    required String relyingParty,
    required String challenge,
    UserVerificationPreference userVerificationPreference =
        UserVerificationPreference.required,
  });

  Future<AuthenticationResponse> authenticateWithPasskey({
    required String relyingParty,
    required String challenge,
    UserVerificationPreference userVerificationPreference =
        UserVerificationPreference.required,
    List<String> allowedCredentials = const [],
  });
}
