import 'package:chatapp/src/core/localization/locale_bloc.dart';
import 'package:chatapp/src/features/auth/data/data_sources/firebase_auth_service.dart';
import 'package:chatapp/src/features/auth/data/data_sources/firebase_storage_service.dart';
import 'package:chatapp/src/features/auth/data/data_sources/user_profile_service.dart';
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
import 'package:chatapp/src/features/chats/data/data_sources/chat_service.dart';
import 'package:chatapp/src/features/chats/data/data_sources/chats_service.dart';
import 'package:chatapp/src/features/chats/data/repository/chat_repository_impl.dart';
import 'package:chatapp/src/features/chats/data/repository/chats_repository_impl.dart';
import 'package:chatapp/src/features/chats/domain/repository/chat_repository.dart';
import 'package:chatapp/src/features/chats/domain/repository/chats_repository.dart';
import 'package:chatapp/src/features/chats/domain/usecases/create_chat_usecase.dart';
import 'package:chatapp/src/features/chats/domain/usecases/delete_message_usecase.dart';
import 'package:chatapp/src/features/chats/domain/usecases/edit_message_usecase.dart';
import 'package:chatapp/src/features/chats/domain/usecases/get_chats_usecase.dart';
import 'package:chatapp/src/features/chats/domain/usecases/get_contacts_usecase.dart';
import 'package:chatapp/src/features/chats/domain/usecases/get_messages_usecase.dart';
import 'package:chatapp/src/features/chats/domain/usecases/send_message_usecase.dart';
import 'package:chatapp/src/features/chats/presentation/chat/bloc/chat_bloc.dart';
import 'package:chatapp/src/features/chats/presentation/contacts/bloc/contacts_bloc.dart';
import 'package:chatapp/src/features/chats/presentation/home/bloc/home_bloc.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

Future<void> initializeDependencies() async {
  /// * Dependencies
  ///
  /// ** Auth:
  locator.registerSingleton<FirebaseAuthService>(FirebaseAuthService());
  locator.registerSingleton<FirebaseStorageService>(FirebaseStorageService());
  locator.registerSingleton<UserProfileService>(UserProfileService());
  locator.registerSingleton<AuthRepository>(AuthRepositoryImpl(locator(), locator(), locator()));

  ///
  /// ** Chats:
  locator.registerSingleton<ChatsService>(ChatsService());
  locator.registerSingleton<ChatService>(ChatService());
  locator.registerSingleton<ChatsRepository>(ChatsRepositoryImpl(locator(), locator(), locator()));
  locator.registerSingleton<ChatRepository>(ChatRepositoryImpl(locator()));

  ///
  ///
  /// * UseCases:
  ///
  /// ** Auth:
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

  ///
  /// ** Chats:
  locator.registerSingleton<GetChatsUseCase>(GetChatsUseCase(locator()));
  locator.registerSingleton<GetContactsUseCase>(GetContactsUseCase(locator()));
  locator.registerSingleton<CreateChatUseCase>(CreateChatUseCase(locator()));
  locator.registerSingleton<SendMessageUseCase>(SendMessageUseCase(locator()));
  locator.registerSingleton<GetMessagesUseCase>(GetMessagesUseCase(locator()));
  locator.registerSingleton<DeleteMessageUseCase>(DeleteMessageUseCase(locator()));
  locator.registerSingleton<EditMessageUseCase>(EditMessageUseCase(locator()));

  /// * Blocs:
  ///
  /// ** Global:
  locator.registerFactory<LocaleBloc>(() => LocaleBloc());
  locator.registerFactory<AuthBloc>(() => AuthBloc(locator(), locator(), locator(), locator(), locator(), locator(), locator()));
  locator.registerFactory<ProfileBloc>(() => ProfileBloc(locator(), locator(), locator(), locator(), locator()));

  ///
  /// ** Features:
  ///
  /// *** Chats:
  locator.registerFactory<HomeBloc>(() => HomeBloc(locator(), locator()));
  locator.registerFactory<ContactsBloc>(() => ContactsBloc(locator(), locator()));
  locator.registerFactory<ChatBloc>(() => ChatBloc(locator(), locator(), locator()));
}
