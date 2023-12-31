import 'dart:io';

import 'package:chatapp/src/features/auth/domain/entities/user_profile_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<void> signInWithPhoneNumber(
    String phoneNumber,
    Function onCodeSent,
    Function onVerificationCompleted,
    Function onVerificationFailed,
  );

  Future<void> signInWithCredentials(AuthCredential credential);

  Future<void> getOrCreateProfile();

  Future<UserProfileEntity> getUserProfile(String uid);

  Future<bool> checkProfileExistenceAndFill();

  Future<void> signInWithCode(String verificationId, String smsCode);

  Future<void> signOut();

  bool isLoggedIn();

  User? getCurrentUser();

  UserProfileEntity? getCurrentUserProfile();

  Future<void> sendRecoveryEmail(String email);

  Future<void> changeDisplayName(String displayName);

  Future<void> changePassword(String password);

  Future<void> changeEmail(String email);

  Future<void> changeBio(String bio);

  Future<void> sendVerifyEmail();

  Future<void> saveProfilePhoto(File photo);
}
