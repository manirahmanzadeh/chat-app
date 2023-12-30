import 'dart:io';

import 'package:chatapp/src/features/auth/data/data_sources/firebase_auth_service.dart';
import 'package:chatapp/src/features/auth/data/data_sources/firebase_storage_service.dart';
import 'package:chatapp/src/features/auth/data/data_sources/user_profile_service.dart';
import 'package:chatapp/src/features/auth/domain/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthService _authService;
  final FirebaseStorageService _storageService;
  final UserProfileService _userProfileService;

  const AuthRepositoryImpl(
    this._authService,
    this._storageService,
    this._userProfileService,
  );

  @override
  Future<void> signOut() async {
    await _authService.signOut();
    _userProfileService.signOut();
  }

  @override
  bool isLoggedIn() {
    return _authService.currentUser != null;
  }

  @override
  User? getCurrentUser() {
    return _authService.currentUser;
  }

  @override
  Future<void> sendRecoveryEmail(String email) {
    return _authService.sendRecoveryEmail(email: email);
  }

  @override
  Future<void> changeDisplayName(String displayName) async {
    await _authService.changeDisplayName(displayName);
    await _userProfileService.updateUserProfile(_authService.currentUser!);
  }

  @override
  Future<void> changeEmail(String email) async {
    await _authService.changeEmail(email);
    await _userProfileService.updateUserProfile(_authService.currentUser!);
  }

  @override
  Future<void> changePassword(String password) async {
    await _authService.changePassword(password);
    await _userProfileService.updateUserProfile(_authService.currentUser!);
  }

  @override
  Future<void> sendVerifyEmail() {
    return _authService.sendVerificationEmail();
  }

  @override
  Future<void> saveProfilePhoto(File photo) async {
    final downloadUrl = await _storageService.uploadProfilePhoto(photo, _authService.currentUser!);
    await _authService.changeProfilePhoto(downloadUrl);
    await _userProfileService.updateUserProfile(_authService.currentUser!);
  }

  @override
  Future<void> changeBio(String bio) async {
    await _userProfileService.updateUserProfile(_authService.currentUser!, bio);
  }

  @override
  Future<void> signInWithPhoneNumber(
    String phoneNumber,
    Function onCodeSent,
    Function onVerificationCompleted,
    Function onVerificationFailed,
  ) {
    return _authService.signInWithPhoneNumber(
      phoneNumber,
      onCodeSent,
      onVerificationCompleted,
      onVerificationFailed,
    );
  }

  @override
  Future<void> signInWithCredentials(AuthCredential credential) {
    return _authService.signInWithCredential(credential);
  }

  @override
  Future<void> signInWithCode(String verificationId, String smsCode) {
    return _authService.signInWithCode(verificationId, smsCode);
  }
}
