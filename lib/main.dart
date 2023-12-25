import 'package:chatapp/src/core/app.dart';
import 'package:chatapp/src/core/locator.dart';
import 'package:chatapp/src/features/auth/presentation/register/screens/login_screen.dart';
import 'package:chatapp/src/features/chats/presentation/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'src/features/auth/domain/repository/auth_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDependencies();
  final isLoggedIn = locator<AuthRepository>().isLoggedIn();
  runApp(
    App(
      initialRoute: isLoggedIn ? HomeScreen.routeName : LoginScreen.routeName,
    ),
  );
}
