import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_passkeys/flutter_passkeys.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';
import '../../setup_services.dart';

class RegisterService {
  late final FirebaseAuth _auth;

  RegisterService() {
    _auth = getIt.get<FirebaseAuth>();
  }

  Future<User?> register(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        throw 'The account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        throw 'Invalid email.';
      } else {
        throw 'Unknown error.';
      }
    }
  }

  Future<User?> registerWithPasskey(String email) async {
    try {
      final res = await http.get(
        Uri.parse(
            "$functionsUrlBase/generateRegistrationOps?email=$email&debug=$kDebugMode"),
      );
      if (res.statusCode == 200) {
        final data = res.body;
        final decoded = jsonDecode(data);

        final webatuhresp = await getIt.get<FlutterPasskeys>().createPasskey(
              userID: decoded["user"]["id"],
              displayName: decoded["user"]["displayName"],
              relyingParty: decoded["rp"]["id"],
              challenge: decoded["challenge"],
            );
        try {
          final token = await http.post(
            Uri.parse(
              "$functionsUrlBase/confirmRegistration?debug=$kDebugMode",
            ),
            body: jsonEncode({
              "email": email,
              "clientResponse": {
                "id": webatuhresp.credId,
                "rawId": base64Url
                    .encode(webatuhresp.rawId.asUint8List())
                    .replaceAll("=", ""),
                "response": {
                  "clientDataJSON": webatuhresp.response,
                  "attestationObject":
                      base64Url.encode(webatuhresp.attestation),
                },
                "type": "public-key",
                "clientExtensionResults": {}
              },
            }),
          );
          if (token.statusCode == 200) {
            final data = token.body;
            final userCredential = await _auth.signInWithCustomToken(data);
            return userCredential.user;
          } else {
            throw "Unknown error. Cant confirm registration";
          }
        } catch (e) {
          debugPrint(e.toString());
          throw "Unknown error. Cant confirm registration";
        }
      } else {
        throw 'Unknown error. Cant get options';
      }
    } catch (e) {
      debugPrint(e.toString());
      throw 'Unknown error.';
    }
  }
}
