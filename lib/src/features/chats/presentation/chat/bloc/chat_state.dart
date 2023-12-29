import 'package:chatapp/src/features/chats/domain/entities/chat_entity.dart';
import 'package:equatable/equatable.dart';

abstract class ChatState extends Equatable {
  final ChatEntity? chat;
  final Exception? exception;

  const ChatState({this.chat, this.exception});

  @override
  List<Object> get props => [chat!, exception!];
}

class LoadingChatState extends ChatState {
  const LoadingChatState();
}

class LoadedChatState extends ChatState {
  const LoadedChatState(ChatEntity chat) : super(chat: chat);
}

class ErrorChatState extends ChatState {
  const ErrorChatState(Exception exception) : super(exception: exception);
}
