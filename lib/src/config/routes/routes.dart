import 'package:chatapp/src/core/locator.dart';
import 'package:chatapp/src/features/auth/data/data_sources/user_profile_service.dart';
import 'package:chatapp/src/features/auth/domain/repository/auth_repository.dart';
import 'package:chatapp/src/features/auth/presentation/account/screens/changename_screen.dart';
import 'package:chatapp/src/features/auth/presentation/account/screens/changepasword_screen.dart';
import 'package:chatapp/src/features/auth/presentation/account/screens/email_screen.dart';
import 'package:chatapp/src/features/auth/presentation/account/screens/profile_screen.dart';
import 'package:chatapp/src/features/auth/presentation/register/screens/signin_screen.dart';
import 'package:chatapp/src/features/auth/presentation/register/screens/verification_screen.dart';
import 'package:chatapp/src/features/chats/presentation/chat/chat_screen.dart';
import 'package:chatapp/src/features/chats/presentation/contacts/contacts_screen.dart';
import 'package:chatapp/src/features/chats/presentation/home/home_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static Map<String, Widget Function(BuildContext)> routes = {
    SignInScreen.routeName: (context) => const SignInScreen(),
    VerificationScreen.routeName: (context) => const VerificationScreen(),
    ProfileScreen.routeName: (context) => const ProfileScreen(),
    ChangeNameScreen.routeName: (context) => const ChangeNameScreen(),
    EmailScreen.routeName: (context) => const EmailScreen(),
    ChangePasswordScreen.routeName: (context) => const ChangePasswordScreen(),
    ContactsScreen.routeName: (context) => const ContactsScreen(),
    ChatScreen.routeName: (context) => const ChatScreen(),
    HomeScreen.routeName: (context) {
      final currentUser = locator<AuthRepository>().getCurrentUser();
      if (currentUser != null) {
        locator<UserProfileService>().getOrCreateUserProfile(currentUser);
        return const HomeScreen();
      } else {
        return const SignInScreen();
      }
    },
  };
}
