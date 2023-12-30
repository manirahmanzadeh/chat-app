import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<void> signInWithPhoneNumber(
    String phoneNumber,
    Function onCodeSent,
    Function onVerificationCompleted,
    Function onVerificationFailed,
  );

  Future<void> signInWithCredentials(AuthCredential credential);

  Future<void> signInWithCode(String verificationId, String smsCode);

  Future<void> signOut();

  bool isLoggedIn();

  User? getCurrentUser();

  Future<void> sendRecoveryEmail(String email);

  Future<void> changeDisplayName(String displayName);

  Future<void> changePassword(String password);

  Future<void> changeEmail(String email);

  Future<void> changeBio(String bio);

  Future<void> sendVerifyEmail();

  Future<void> saveProfilePhoto(File photo);
}
