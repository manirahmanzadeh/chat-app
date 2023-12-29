import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/src/core/locator.dart';
import 'package:chatapp/src/features/chats/domain/entities/chat_entity.dart';
import 'package:chatapp/src/features/chats/presentation/chat/bloc/chat_bloc.dart';
import 'package:chatapp/src/features/chats/presentation/chat/bloc/chat_event.dart';
import 'package:chatapp/src/features/chats/presentation/chat/bloc/chat_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  static const routeName = '/chat';

  @override
  Widget build(BuildContext context) {
    final chat = ModalRoute.of(context)!.settings.arguments as ChatEntity;
    return BlocProvider<ChatBloc>(
      create: (_) => locator()..add(LoadChatEvent(chat)),
      child: const _ChatScreen(),
    );
  }
}

class _ChatScreen extends StatelessWidget {
  const _ChatScreen();

  @override
  Widget build(BuildContext context) {
    final staticBlocProvider = BlocProvider.of<ChatBloc>(context, listen: false);
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (_, state) {
        if (state is LoadingChatState) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is ErrorChatState) {
          return Center(
            child: Text('Error: ${state.exception.toString()}'),
          );
        }

        final currentUser = staticBlocProvider.currentUser;
        final chat = state.chat!;
        final otherParticipantUid = chat.participants.firstWhere(
          (uid) => uid != currentUser.uid,
          orElse: () => '',
        );
        final otherUserIndex = chat.participants.indexOf(otherParticipantUid);
        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                SizedBox(
                  height: 32,
                  child: ClipOval(
                    child: CachedNetworkImage(imageUrl: chat.imageUrls[otherUserIndex]),
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(chat.displayNames[otherUserIndex])
              ],
            ),
          ),
        );
      },
    );
  }
}
