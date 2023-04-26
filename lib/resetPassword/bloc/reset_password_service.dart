import 'package:firebase_auth/firebase_auth.dart';

class ResetPasswordService {
  final _auth = FirebaseAuth.instance;

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}