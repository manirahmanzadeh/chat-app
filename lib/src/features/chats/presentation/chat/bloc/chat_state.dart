import 'package:chatapp/src/features/auth/domain/entities/user_profile_entity.dart';
import 'package:chatapp/src/features/chats/domain/entities/chat_entity.dart';
import 'package:chatapp/src/features/chats/domain/entities/message_entity.dart';
import 'package:equatable/equatable.dart';

abstract class ChatState extends Equatable {
  final ChatEntity? chat;
  final UserProfileEntity? userProfile;
  final Stream<List<MessageEntity>>? messagesStream;
  final Exception? exception;
  final MessageEntity? editingMessage;

  const ChatState({
    this.chat,
    this.messagesStream,
    this.exception,
    this.userProfile,
    this.editingMessage,
  });

  @override
  List<Object> get props => [
        chat!,
        exception!,
        userProfile!,
        messagesStream!,
        editingMessage!,
      ];
}

class LoadingChatState extends ChatState {
  const LoadingChatState();
}

class LoadedChatState extends ChatState {
  const LoadedChatState(
    ChatEntity chat,
    Stream<List<MessageEntity>> messagesStream,
    UserProfileEntity userProfileEntity,
  ) : super(
          chat: chat,
          messagesStream: messagesStream,
          userProfile: userProfileEntity,
        );
}

class ErrorChatState extends ChatState {
  const ErrorChatState(Exception exception) : super(exception: exception);
}

class EditingChatState extends ChatState {
  const EditingChatState(
      ChatEntity chat, Stream<List<MessageEntity>> messagesStream, UserProfileEntity userProfileEntity, MessageEntity editingMessage)
      : super(chat: chat, messagesStream: messagesStream, userProfile: userProfileEntity, editingMessage: editingMessage);
}
