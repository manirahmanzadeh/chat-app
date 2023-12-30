import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

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

  String? getUserPhotoUrl(BuildContext context) {
    final user = BlocProvider.of<AuthBloc>(context).getCurrentUser();
    if (user != null) {
      return user.photoURL;
    }
    return null;
  }

  bool hasPhoto(BuildContext context) => getUserPhotoUrl(context) != null;

  String? getUserDisplayName(BuildContext context) {
    final user = BlocProvider.of<AuthBloc>(context).getCurrentUser();
    if (user != null && user.displayName != null && user.displayName!.isNotEmpty) {
      return user.displayName;
    }
    return null;
  }

  bool hasDisplayName(BuildContext context) => getUserDisplayName(context) != null;

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

  void showImagePicker(BuildContext screenContext) {
    showModalBottomSheet(
      context: screenContext,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                _pickImage(ImageSource.gallery, screenContext);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () {
                _pickImage(ImageSource.camera, screenContext);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage(
    ImageSource source,
    BuildContext context,
  ) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      File image = File(pickedFile.path);
      BlocProvider.of<AuthBloc>(context).add(ChangeProfilePhotoAuthEvent(photo: image, context: context));
    }
  }

  onNameSaved(String? value) {
    name = value;
  }

  String? name;

  submitChangeDisplayNameForm(BuildContext context) {
    if (registerFormKey.currentState?.validate() ?? false) {
      registerFormKey.currentState!.save();
      BlocProvider.of<AuthBloc>(context).add(ChangeDisplayNameAuthEvent(displayName: name!, context: context));
    }
  }
}
