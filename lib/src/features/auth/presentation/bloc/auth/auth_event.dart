import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

abstract class AuthEvent {
  const AuthEvent();
}

class SignInPhoneNumberAuthEvent extends AuthEvent {
  final String phoneNumber;
  final BuildContext context;

  const SignInPhoneNumberAuthEvent({
    required this.phoneNumber,
    required this.context,
  });
}

class SignInCodeAuthEvent extends AuthEvent {
  final String smsCode;
  final BuildContext context;

  const SignInCodeAuthEvent({
    required this.smsCode,
    required this.context,
  });
}

class SignInCredentialAuthEvent extends AuthEvent {
  final AuthCredential credential;
  final BuildContext context;

  const SignInCredentialAuthEvent({
    required this.credential,
    required this.context,
  });
}

class SignOutAuthEvent extends AuthEvent {
  final BuildContext context;

  const SignOutAuthEvent({
    required this.context,
  });
}

class SendRecoveryEmailAuthEvent extends AuthEvent {
  final String email;
  final BuildContext context;

  const SendRecoveryEmailAuthEvent({
    required this.email,
    required this.context,
  });
}

class ThrowExceptionAuthEvent extends AuthEvent {
  final Exception exception;

  const ThrowExceptionAuthEvent({
    required this.exception,
  });
}

class LoadAuthEvent extends AuthEvent {
  const LoadAuthEvent();
}

class ChangeProfilePhotoAuthEvent extends AuthEvent {
  final File photo;
  final BuildContext context;

  const ChangeProfilePhotoAuthEvent({required this.photo, required this.context});
}

class ChangeDisplayNameAuthEvent extends AuthEvent {
  final String displayName;
  final BuildContext context;

  const ChangeDisplayNameAuthEvent({required this.displayName, required this.context});
}
