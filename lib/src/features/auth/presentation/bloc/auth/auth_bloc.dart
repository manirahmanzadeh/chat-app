import 'dart:async';

import 'package:chatapp/src/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:chatapp/src/features/auth/domain/usecases/send_recovery_email_usecase.dart';
import 'package:chatapp/src/features/auth/domain/usecases/signin_code_usecase.dart';
import 'package:chatapp/src/features/auth/domain/usecases/signin_credential_usecase.dart';
import 'package:chatapp/src/features/auth/domain/usecases/signin_phone_number_usecase.dart';
import 'package:chatapp/src/features/auth/presentation/register/screens/signin_screen.dart';
import 'package:chatapp/src/features/auth/presentation/register/screens/verification_screen.dart';
import 'package:chatapp/src/features/chats/presentation/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/signout.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInPhoneNumberUseCase _signInPhoneNumberUseCase;
  final SignInCredentialUseCase _signInCredentialUseCase;
  final SignInCodeUseCase _signInCodeUseCase;
  final SignOutUseCase _signOutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final SendRecoveryEmailUseCase _sendRecoveryEmailUseCase;

  String? _verificationId;

  AuthBloc(
    this._signOutUseCase,
    this._getCurrentUserUseCase,
    this._sendRecoveryEmailUseCase,
    this._signInPhoneNumberUseCase,
    this._signInCredentialUseCase,
    this._signInCodeUseCase,
  ) : super(const LoadedAuthState()) {
    on<SignInPhoneNumberAuthEvent>(_onSignInWithPhoneNumber);
    on<SignOutAuthEvent>(_onSignOut);
    on<SendRecoveryEmailAuthEvent>(_onSendRecoveryEmail);
    on<SignInCodeAuthEvent>(_onSignInCode);
    on<SignInCredentialAuthEvent>(_onSignInCredential);
    on<ThrowExceptionAuthEvent>(_onThrowException);
    on<LoadAuthEvent>(_onLoad);
  }

  _onSignOut(SignOutAuthEvent event, Emitter<AuthState> emit) async {
    emit(const LoadingAuthState());
    try {
      await _signOutUseCase();
      emit(const LoadedAuthState());
      Navigator.pushReplacementNamed(
        event.context,
        SignInScreen.routeName,
      );
    } catch (e) {
      emit(const LoadedAuthState());
      ScaffoldMessenger.of(event.context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  _onSendRecoveryEmail(SendRecoveryEmailAuthEvent event, Emitter<AuthState> emit) async {
    emit(const LoadingAuthState());
    try {
      await _sendRecoveryEmailUseCase(
        params: event.email,
      );
      emit(const LoadedAuthState());
      ScaffoldMessenger.of(event.context).showSnackBar(const SnackBar(content: Text('Recovery email sent!')));
    } catch (e) {
      emit(const LoadedAuthState());
      ScaffoldMessenger.of(event.context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  User? getCurrentUser() {
    return _getCurrentUserUseCase();
  }

  FutureOr<void> _onSignInWithPhoneNumber(SignInPhoneNumberAuthEvent event, Emitter<AuthState> emit) async {
    emit(const LoadingAuthState());
    try {
      await _signInPhoneNumberUseCase(
        params: {
          'phoneNumber': event.phoneNumber,
          'onCodeSent': (String verificationId) {
            _verificationId = verificationId;
            add(const LoadAuthEvent());
            Navigator.pushNamed(event.context, VerificationScreen.routeName);
          },
          'onVerificationCompleted': (AuthCredential credential) async {
            add(SignInCredentialAuthEvent(credential: credential, context: event.context));
          },
          'onVerificationFailed': (Exception e) async {
            add(ThrowExceptionAuthEvent(exception: e));
          },
        },
      );
    } on Exception catch (e) {
      emit(ErrorAuthState(e));
    }
  }

  FutureOr<void> _onSignInCode(SignInCodeAuthEvent event, Emitter<AuthState> emit) async {
    emit(const LoadingAuthState());
    try {
      await _signInCodeUseCase(
        params: {
          'verificationId': _verificationId,
          'smsCode': event.smsCode,
        },
      );
      Navigator.pushNamed(event.context, HomeScreen.routeName);
      emit(const LoadedAuthState());
    } on Exception catch (e) {
      emit(ErrorAuthState(e));
    }
  }

  FutureOr<void> _onSignInCredential(SignInCredentialAuthEvent event, Emitter<AuthState> emit) async {
    emit(const LoadingAuthState());
    try {
      await _signInCredentialUseCase(params: event.credential);
      emit(const LoadedAuthState());
      Navigator.pushNamed(event.context, HomeScreen.routeName);
    } on Exception catch (e) {
      emit(ErrorAuthState(e));
    }
  }

  FutureOr<void> _onThrowException(ThrowExceptionAuthEvent event, Emitter<AuthState> emit) {
    emit(ErrorAuthState(event.exception));
  }

  FutureOr<void> _onLoad(LoadAuthEvent event, Emitter<AuthState> emit) {
    emit(const LoadedAuthState());
  }
}
