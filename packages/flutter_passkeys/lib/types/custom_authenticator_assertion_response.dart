import 'dart:typed_data';

import 'package:js/js.dart';

@JS("AuthenticatorAssertionResponse")
@staticInterop
class CustomAuthenticatorAssertionResponse {}

extension CustomAuthenticatorAssertionResponseExtension
    on CustomAuthenticatorAssertionResponse {
  external ByteBuffer? get userHandle;
  external ByteBuffer? get getauthenticatorData;
  external ByteBuffer? get signature;
}
