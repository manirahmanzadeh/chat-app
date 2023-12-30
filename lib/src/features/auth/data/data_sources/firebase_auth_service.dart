import 'dart:async';

import 'package:chatapp/src/core/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithPhoneNumber(
      String phoneNumber, Function onCodeSent, Function onVerificationCompleted, Function onVerificationFailed) async {
    print('phoneNumber: ');
    print(phoneNumber);
    await _firebaseAuth
        .verifyPhoneNumber(
          phoneNumber: phoneNumber,
          timeout: const Duration(seconds: 60),
          verificationCompleted: (AuthCredential credential) async {
            onVerificationCompleted(credential);
          },
          verificationFailed: (Exception e) {
            onVerificationFailed(e);
          },
          codeSent: (String verificationId, [int? forceResendingToken]) {
            onCodeSent(verificationId);
          },
          codeAutoRetrievalTimeout: (_) {},
        )
        .onError((error, stackTrace) => throw (Exception(error)));
  }

  Future<void> signInWithCredential(AuthCredential credential) {
    return _firebaseAuth.signInWithCredential(credential).onError((error, stackTrace) => throw (Exception(error)));
  }

  Future<void> signInWithCode(String verificationId, String smsCode) async {
    AuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);

    await _firebaseAuth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut().onError((error, stackTrace) => throw (Exception(error)));
  }

  Future<void> sendRecoveryEmail({
    required String email,
  }) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> changeDisplayName(String displayName) async {
    await _firebaseAuth.currentUser
        ?.updateDisplayName(
          displayName,
        )
        .onError((error, stackTrace) => throw (Exception(error)));
  }

  Future<void> changeEmail(String email) async {
    await _firebaseAuth.currentUser
        ?.updateEmail(
      email,
    )
        .onError((error, stackTrace) {
      print(error);
      throw (Exception(error));
    });
  }

  Future<void> changePassword(String password) async {
    await _firebaseAuth.currentUser
        ?.updatePassword(
          password,
        )
        .onError((error, stackTrace) => throw (Exception(error)));
  }

  Future<void> changeProfilePhoto(String url) async {
    await _firebaseAuth.currentUser
        ?.updatePhotoURL(
          url,
        )
        .onError((error, stackTrace) => throw (Exception(error)));
  }

  Future<void> sendVerificationEmail() async {
    await _firebaseAuth.currentUser
        ?.sendEmailVerification(ActionCodeSettings(url: deeplLink))
        .onError((error, stackTrace) => throw (Exception(error)));
  }
}
