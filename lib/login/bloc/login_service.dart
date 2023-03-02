import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_passkeys/flutter_passkeys.dart';
import 'package:http/http.dart' as http;
import 'package:moodtracker/constants.dart';
import 'package:moodtracker/setup_services.dart';

class LoginService {
  late final FirebaseAuth _auth;

  LoginService() {
    _auth = getIt.get<FirebaseAuth>();
  }

  User? getUser() {
    return _auth.currentUser;
  }

  Future<User?> login(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        throw 'Wrong password provided for that user.';
      } else if (e.code == 'invalid-email') {
        throw 'Invalid email.';
      } else if (e.code == 'user-disabled') {
        throw 'User disabled.';
      } else {
        throw 'Unknown error.';
      }
    }
  }

  Future<User?> loginWithPasskey() async {
    try {
      final res = await http.get(
        Uri.parse(
            "$functionsUrlBase/generateAuthenticationOps?debug=$kDebugMode"),
      );
      if (res.statusCode == 200) {
        final data = res.body;
        final decoded = jsonDecode(data);

        final webatuhresp =
            await getIt.get<FlutterPasskeys>().authenticateWithPasskey(
                  relyingParty: decoded["rpId"],
                  challenge: decoded["challenge"],
                );
        try {
          final token = await http.post(
            Uri.parse(
              "$functionsUrlBase/confirmAuthentication?debug=$kDebugMode",
            ),
            body: jsonEncode({
              "transactionId": decoded["transactionId"],
              "userID": webatuhresp.userId,
              "clientResponse": {
                "id": webatuhresp.credId,
                "rawId": base64UrlEncode(webatuhresp.rawId).replaceAll("=", ""),
                "type": "public-key",
                "response": {
                  "clientDataJSON": base64UrlEncode(webatuhresp.clientDataJSON),
                  "signature": base64UrlEncode(webatuhresp.signature),
                  "authenticatorData":
                      base64UrlEncode(webatuhresp.authenticatorData),
                },
                "clientExtensionResults": "{}",
              },
            }),
          );
          if (token.statusCode == 200) {
            final data = token.body;
            final userCredential = await _auth.signInWithCustomToken(data);
            return userCredential.user;
          } else {
            throw 'Unknown error.';
          }
        } on Exception catch (e) {
          throw 'Unknown error.';
        }
      } else {
        throw 'Unknown error.';
      }
    } on Exception catch (e) {
      throw 'Unknown error.';
    }
  }
}
