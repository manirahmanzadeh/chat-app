import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/src/core/locator.dart';
import 'package:chatapp/src/features/chats/domain/entities/message_entity.dart';
import 'package:chatapp/src/features/chats/presentation/chat/bloc/chat_bloc.dart';
import 'package:chatapp/src/features/chats/presentation/chat/bloc/chat_state.dart';
import 'package:chatapp/src/features/chats/presentation/chat/components/chat_input.dart';
import 'package:chatapp/src/features/chats/presentation/chat/components/message_bubble.dart';
import 'package:chatapp/src/features/chats/presentation/chat/components/sending_message_bubble.dart';
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
      create: (context) => locator()..initChat(context, chat, userProfile),
      child: const _ChatScreen(),
    );
  }
}

class _ChatScreen extends StatelessWidget {
  const _ChatScreen();

  @override
  Widget build(BuildContext context) {
    final staticBlocProvider = BlocProvider.of<ChatBloc>(context, listen: false);
    // final blocProvider = BlocProvider.of<ChatBloc>(context, listen: true);
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
          return Scaffold(
              body: Center(
              child: Text('Error: ${state.exception.toString()}'),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: InkWell(
              onTap: staticBlocProvider.goToContact,
              child: Row(
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
                        padding: const EdgeInsets.only(top: 16),
                        itemCount: snapshot.data!.length,
                        reverse: true,
                        itemBuilder: (context, index) {
                          MessageEntity message = snapshot.data![index];
                          if (index == 0) {
                            return Column(
                              children: [
                                MessageBubble(
                                  message: message,
                                  myMessage: message.senderUid != state.userProfile!.uid,
                                  displayName: state.userProfile!.displayName ?? '',
                                  deleteMessage: staticBlocProvider.deleteMessage,
                                  openEditMessage: staticBlocProvider.openEditMessage,
                                ),
                                Column(
                                  children: state.sending!
                                      .map(
                                        (e) => SMBubble(sm: e),
                                      )
                                      .toList(),
                                ),
                              ],
                            );
                          }
                          return MessageBubble(
                            message: message,
                            myMessage: message.senderUid != state.userProfile!.uid,
                            displayName: state.userProfile!.displayName ?? '',
                            deleteMessage: staticBlocProvider.deleteMessage,
                            openEditMessage: staticBlocProvider.openEditMessage,
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              ChatInput(
                onSendMessage: staticBlocProvider.sendMessage,
                messageController: staticBlocProvider.messageController,
                editingMessage: state.editingMessage,
                closeTargetMessage: staticBlocProvider.closeTargetMessage,
                submitEditMessage: staticBlocProvider.submitEditMessage,
                closeFileUpload: staticBlocProvider.closeFileUpload,
                attachFile: staticBlocProvider.setFile,
                file: state.file,
              ),
            ],
          ),
        );
      },
    );
  }
}
