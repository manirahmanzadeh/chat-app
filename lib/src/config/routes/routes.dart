import 'package:chatapp/src/core/locator.dart';
import 'package:chatapp/src/features/auth/data/data_sources/user_profile_service.dart';
import 'package:chatapp/src/features/auth/domain/repository/auth_repository.dart';
import 'package:chatapp/src/features/auth/presentation/account/screens/changename_screen.dart';
import 'package:chatapp/src/features/auth/presentation/account/screens/changepasword_screen.dart';
import 'package:chatapp/src/features/auth/presentation/account/screens/email_screen.dart';
import 'package:chatapp/src/features/auth/presentation/account/screens/profile_screen.dart';
import 'package:chatapp/src/features/auth/presentation/register/screens/forget_password_screen.dart';
import 'package:chatapp/src/features/auth/presentation/register/screens/login_screen.dart';
import 'package:chatapp/src/features/auth/presentation/register/screens/signup_screen.dart';
import 'package:chatapp/src/features/chats/presentation/home/home_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static Map<String, Widget Function(BuildContext)> routes = {
    LoginScreen.routeName: (context) => const LoginScreen(),
    SignUpScreen.routeName: (context) => const SignUpScreen(),
    ForgetPasswordScreen.routeName: (context) => const ForgetPasswordScreen(),
    ProfileScreen.routeName: (context) => const ProfileScreen(),
    ChangeNameScreen.routeName: (context) => const ChangeNameScreen(),
    EmailScreen.routeName: (context) => const EmailScreen(),
    ChangePasswordScreen.routeName: (context) => const ChangePasswordScreen(),
    HomeScreen.routeName: (context) {
      final currentUser = locator<AuthRepository>().getCurrentUser();
      if (currentUser != null) {
        locator<UserProfileService>().getOrCreateUserProfile(currentUser);
        return const HomeScreen();
      } else {
        return const LoginScreen();
      }
    },
  };
}
