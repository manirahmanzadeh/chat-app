import 'dart:io';

import 'package:chatapp/src/features/auth/data/data_sources/firebase_auth_service.dart';
import 'package:chatapp/src/features/auth/data/data_sources/firebase_storage_service.dart';
import 'package:chatapp/src/features/auth/data/data_sources/user_profile_service.dart';
import 'package:chatapp/src/features/auth/domain/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
  Future<void> createUserWithEmailAndPassword(String email, String password) async {
    await _authService.createUserWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _authService.signInWithEmailAndPassword(email: email, password: password);
  }

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
  Future<void> signIngWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(
      loginResult.accessToken!.token,
    );

    await _authService.signInWithCredentials(facebookAuthCredential);

  }

  @override
  Future<void> signIngWithGoogle() async {
    // Trigger the authentication flow

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await _authService.signInWithCredentials(credential);

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

}
