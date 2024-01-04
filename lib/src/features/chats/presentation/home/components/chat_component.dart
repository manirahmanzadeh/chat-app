import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/src/core/locator.dart';
import 'package:chatapp/src/features/auth/domain/entities/user_profile_entity.dart';
import 'package:chatapp/src/features/auth/domain/usecases/get_user_profile_usecase.dart';
import 'package:chatapp/src/features/chats/domain/entities/chat_entity.dart';
import 'package:chatapp/src/features/chats/presentation/chat/chat_screen.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/home_bloc.dart';

class ChatComponent extends StatelessWidget {
  const ChatComponent({super.key, required this.chat});

  final ChatEntity chat;

  @override
  Widget build(BuildContext context) {
    final currentUser = BlocProvider.of<HomeBloc>(context).currentUser;
    final String uid = chat.participants.firstWhere(
      (uid) => uid != currentUser.uid,
      orElse: () => '',
    );
    return BlocProvider(
      create: (_) => ChatComponentBloc(locator(), uid),
      child: BlocBuilder<ChatComponentBloc, ChatComponentState>(
        builder: (_, state) => AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          child: state is LoadingChatComponentState
              ? const ListTile(
                  leading: CircularProgressIndicator(),
                  title: Text('Getting data'),
                )
              : state is ErrorChatComponentState
                  ? const ListTile(
                      leading: Icon(Icons.error),
                      title: Text('Error Getting data'),
                    )
                  : ListTile(
                      onTap: () => Navigator.pushNamed(
                        context,
                        ChatScreen.routeName,
                        arguments: {
                          'chat': chat,
                          'userProfile': state.userProfile!,
                        },
                      ),
                      leading: SizedBox(
                        width: 50,
                        height: 50,
                        child: ClipOval(
                          child: CachedNetworkImage(imageUrl: state.userProfile!.photoURL ?? ''),
                        ),
                      ),
                      title: Text(state.userProfile!.displayName ?? ''),
                    ),
        ),
      ),
    );
  }
}

class ChatComponentBloc extends Cubit<ChatComponentState> {
  final GetUserProfileUseCase _getUserProfileUseCase;
  final String uid;

  ChatComponentBloc(
    this._getUserProfileUseCase,
    this.uid,
  ) : super(const LoadingChatComponentState()) {
    getUserProfile();
  }

  Future<void> getUserProfile() async {
    emit(const LoadingChatComponentState());
    try {
      final userProfile = await _getUserProfileUseCase(params: uid);
      emit(LoadedChatComponentState(userProfile));
    } on Exception catch (e) {
      emit(ErrorChatComponentState(e));
    }
  }
}

abstract class ChatComponentState extends Equatable {
  final UserProfileEntity? userProfile;
  final Exception? exception;

  const ChatComponentState({
    this.userProfile,
    this.exception,
  });

  @override
  List<Object?> get props => [userProfile!, exception!];
}

class LoadedChatComponentState extends ChatComponentState {
  const LoadedChatComponentState(UserProfileEntity userProfileEntity)
      : super(
          userProfile: userProfileEntity,
        );
}

class LoadingChatComponentState extends ChatComponentState {
  const LoadingChatComponentState();
}

class ErrorChatComponentState extends ChatComponentState {
  const ErrorChatComponentState(Exception exception)
      : super(
          exception: exception,
        );
}
