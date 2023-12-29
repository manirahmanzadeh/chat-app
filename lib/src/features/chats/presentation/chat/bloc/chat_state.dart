import 'package:chatapp/src/features/chats/domain/entities/chat_entity.dart';
import 'package:chatapp/src/features/chats/domain/entities/message_entity.dart';
import 'package:equatable/equatable.dart';

abstract class ChatState extends Equatable {
  final ChatEntity? chat;
  final Stream<List<MessageEntity>>? messagesStream;
  final Exception? exception;

  const ChatState({this.chat, this.messagesStream, this.exception});

  @override
  List<Object> get props => [chat!, exception!];
}

class LoadingChatState extends ChatState {
  const LoadingChatState();
}

class LoadedChatState extends ChatState {
  const LoadedChatState(
    ChatEntity chat,
    Stream<List<MessageEntity>> messagesStream,
  ) : super(
          chat: chat,
          messagesStream: messagesStream,
        );
}

class ErrorChatState extends ChatState {
  const ErrorChatState(Exception exception) : super(exception: exception);
}
