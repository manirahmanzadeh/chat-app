import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc(this.context) : super(const LoadedRegisterState());
  BuildContext context;

  final registerFormKey = GlobalKey<FormState>();

  String? phoneNumber;
  String? smsCode;

  onSavedPhoneNumber(String? value) {
    phoneNumber = value;
  }

  onChangeSmsCode(String? value) {
    smsCode = value;
  }

  submitLoginForm() {
    if (registerFormKey.currentState!.validate()) {
      registerFormKey.currentState!.save();
      BlocProvider.of<AuthBloc>(context).add(
        SignInPhoneNumberAuthEvent(
          phoneNumber: phoneNumber!,
          context: context,
        ),
      );
    }
  }

  submitVerificationForm() {
    if (registerFormKey.currentState!.validate()) {
      registerFormKey.currentState!.save();
      BlocProvider.of<AuthBloc>(context).add(
        SignInCodeAuthEvent(smsCode: smsCode ?? '', context: context),
      );
    }
  }
}
