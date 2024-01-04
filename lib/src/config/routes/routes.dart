import 'package:chatapp/src/features/auth/domain/repository/auth_repository.dart';
import 'package:chatapp/src/features/auth/presentation/account/screens/changename_screen.dart';
import 'package:chatapp/src/features/auth/presentation/account/screens/changepasword_screen.dart';
import 'package:chatapp/src/features/auth/presentation/account/screens/email_screen.dart';
import 'package:chatapp/src/features/auth/presentation/account/screens/profile_screen.dart';
import 'package:chatapp/src/features/auth/presentation/register/screens/set_name_and_photo_screen.dart';
import 'package:chatapp/src/features/auth/presentation/register/screens/signin_screen.dart';
import 'package:chatapp/src/features/auth/presentation/register/screens/verification_screen.dart';
import 'package:chatapp/src/features/chats/presentation/chat/chat_screen.dart';
import 'package:chatapp/src/features/chats/presentation/contact/contact_screen.dart';
import 'package:chatapp/src/features/chats/presentation/contacts/contacts_screen.dart';
import 'package:chatapp/src/features/chats/presentation/home/home_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  final AuthRepository _authRepository;

  AppRoutes(this._authRepository);

  Map<String, Widget Function(BuildContext)> routes() => {
        SignInScreen.routeName: (context) => const SignInScreen(),
        VerificationScreen.routeName: (context) => const VerificationScreen(),
        ProfileScreen.routeName: (context) => const ProfileScreen(),
        ChangeNameScreen.routeName: (context) => const ChangeNameScreen(),
        EmailScreen.routeName: (context) => const EmailScreen(),
        ChangePasswordScreen.routeName: (context) => const ChangePasswordScreen(),
        ContactsScreen.routeName: (context) => const ContactsScreen(),
        ChatScreen.routeName: (context) => const ChatScreen(),
        ContactScreen.routeName: (context) => const ContactScreen(),
        HomeScreen.routeName: (context) {
          final currentUser = _authRepository.getCurrentUser();
          if (currentUser != null) {
            _authRepository.getOrCreateProfile();
            if (currentUser.displayName == null || currentUser.displayName!.isEmpty) {
              return const SetNameAndPhotoScreen();
            }
            return const HomeScreen();
          } else {
            return const SignInScreen();
          }
        },
      };
}
