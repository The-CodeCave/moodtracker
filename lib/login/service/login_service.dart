import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:moodtracker/login/model/login_exception.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
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
      throw LoginException.fromCode(e);
    } catch (e) {
      debugPrint('Unhandled exception: $e');
      rethrow;
    }
  }

  static String generateNonce([int length = 32]) {
    const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  static String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<User?> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    await FirebaseAuth.instance.signInWithCredential(oauthCredential);

    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseAuth.instance.currentUser!.updateDisplayName('${appleCredential.givenName} ${appleCredential.familyName}');

      return _auth.currentUser;
    } else {
      throw 'Login failed';
    }
  }

  Future<User?> signInWithAppleWeb() async {
    final provider = OAuthProvider("apple.com");
    await _auth.signInWithPopup(provider);
    return _auth.currentUser;
  }

  Future<User?> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn(
      scopes: [
        'email',
      ],
    ).signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    if (googleAuth != null) {
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      await _auth.signInWithCredential(credential);
      return _auth.currentUser;
    }
    return null;
  }

  Future<User?> signInWithGoogleWeb() async {
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    try {
      await _auth.signInWithPopup(googleProvider);
      return _auth.currentUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> register(String email, String password) async {
    // TODO: implement register function
    return null;
  }

  Future<User?> loginWithPasskey() async {
    try {
      final res = await http.get(
        Uri.parse("$functionsUrlBase/generateAuthenticationOps?debug=$kDebugMode"),
      );
      if (res.statusCode == 200) {
        final data = res.body;
        final decoded = jsonDecode(data);

        final webatuhresp = await getIt.get<FlutterPasskeys>().authenticateWithPasskey(
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
                  "authenticatorData": base64UrlEncode(webatuhresp.authenticatorData),
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
        } on Exception catch (_) {
          rethrow;
        }
      } else {
        throw 'Unknown error.';
      }
    } on Exception catch (_) {
      rethrow;
    }
  }
}
