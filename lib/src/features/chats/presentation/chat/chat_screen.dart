import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/src/core/locator.dart';
import 'package:chatapp/src/features/chats/domain/entities/message_entity.dart';
import 'package:chatapp/src/features/chats/presentation/chat/bloc/chat_bloc.dart';
import 'package:chatapp/src/features/chats/presentation/chat/bloc/chat_event.dart';
import 'package:chatapp/src/features/chats/presentation/chat/bloc/chat_state.dart';
import 'package:chatapp/src/features/chats/presentation/chat/components/chat_input.dart';
import 'package:chatapp/src/features/chats/presentation/chat/components/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  static const routeName = '/chat';

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final chat = arguments['chat'];
    final userProfile = arguments['userProfile'];
    return BlocProvider<ChatBloc>(
      create: (_) => locator()..add(LoadChatEvent(chat, userProfile)),
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
          return Scaffold(
            backgroundColor: Colors.white.withOpacity(0.9),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is ErrorChatState) {
          return Scaffold(
            backgroundColor: Colors.white.withOpacity(0.9),
            body: Center(
              child: Text('Error: ${state.exception.toString()}'),
            ),
          );
        }
        return Scaffold(
          backgroundColor: Colors.white.withOpacity(0.9),
          appBar: AppBar(
            title: Row(
              children: [
                SizedBox(
                  height: 32,
                  child: ClipOval(
                    child: CachedNetworkImage(imageUrl: state.userProfile!.photoURL ?? ''),
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(state.userProfile!.displayName ?? '')
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder<List<MessageEntity>>(
                  stream: state.messagesStream!,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('Send a Message'),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        reverse: true,
                        itemBuilder: (context, index) {
                          MessageEntity message = snapshot.data![index];
                          return MessageBubble(
                            message: message,
                            myMessage: message.senderUid != state.userProfile!.uid,
                            displayName: state.userProfile!.displayName ?? '',
                            deleteMessage: staticBlocProvider.deleteMessage,
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              ChatInput(onSendMessage: (text) => staticBlocProvider.add(SendMessageChatEvent(text))),
            ],
          ),
        );
      },
    );
  }
}
