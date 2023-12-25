import 'package:chatapp/src/core/localization/locale_bloc.dart';
import 'package:chatapp/src/features/auth/data/data_sources/firebase_auth_service.dart';
import 'package:chatapp/src/features/auth/data/data_sources/firebase_storage_service.dart';
import 'package:chatapp/src/features/auth/data/repository/auth_repository_impl.dart';
import 'package:chatapp/src/features/auth/domain/repository/auth_repository.dart';
import 'package:chatapp/src/features/auth/domain/usecases/edit_user_usecases.dart';
import 'package:chatapp/src/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:chatapp/src/features/auth/domain/usecases/send_recovery_email_usecase.dart';
import 'package:chatapp/src/features/auth/domain/usecases/signin_email_password.dart';
import 'package:chatapp/src/features/auth/domain/usecases/signin_facebook_usecase.dart';
import 'package:chatapp/src/features/auth/domain/usecases/signing_google_usecase.dart';
import 'package:chatapp/src/features/auth/domain/usecases/signout.dart';
import 'package:chatapp/src/features/auth/domain/usecases/signup_email_password.dart';
import 'package:chatapp/src/features/auth/presentation/account/bloc/profile_bloc.dart';
import 'package:chatapp/src/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

Future<void> initializeDependencies() async {
  /// Dependencies

  /// Auth:
  locator.registerSingleton<FirebaseAuthService>(FirebaseAuthService());
  locator.registerSingleton<FirebaseStorageService>(FirebaseStorageService());
  locator.registerSingleton<AuthRepository>(AuthRepositoryImpl(locator(), locator()));

  ///UseCases

  ///Auth:
  locator.registerSingleton<SignInWithEmailAndPasswordUseCase>(SignInWithEmailAndPasswordUseCase(locator()));
  locator.registerSingleton<SignUpWithEmailAndPasswordUseCase>(SignUpWithEmailAndPasswordUseCase(locator()));
  locator.registerSingleton<SignOutUseCase>(SignOutUseCase(locator()));
  locator.registerSingleton<GetCurrentUserUseCase>(GetCurrentUserUseCase(locator()));
  locator.registerSingleton<SendRecoveryEmailUseCase>(SendRecoveryEmailUseCase(locator()));
  locator.registerSingleton<SignInWithGoogleUseCase>(SignInWithGoogleUseCase(locator()));
  locator.registerSingleton<SignInWithFacebookUseCase>(SignInWithFacebookUseCase(locator()));
  locator.registerSingleton<ChangeDisplayNameUseCase>(ChangeDisplayNameUseCase(locator()));
  locator.registerSingleton<ChangeEmailUseCase>(ChangeEmailUseCase(locator()));
  locator.registerSingleton<ChangePasswordUseCase>(ChangePasswordUseCase(locator()));
  locator.registerSingleton<SendVerifyEmailUseCase>(SendVerifyEmailUseCase(locator()));
  locator.registerSingleton<ChangeProfilePhotoUseCase>(ChangeProfilePhotoUseCase(locator()));

  ///Blocs

  ///Global:
  locator.registerFactory<LocaleBloc>(() => LocaleBloc());
  locator.registerFactory<AuthBloc>(() => AuthBloc(locator(), locator(), locator(), locator(), locator(), locator(), locator()));
  locator.registerFactory<ProfileBloc>(() => ProfileBloc(locator(), locator(), locator(), locator(), locator()));

  ///Features:
}
