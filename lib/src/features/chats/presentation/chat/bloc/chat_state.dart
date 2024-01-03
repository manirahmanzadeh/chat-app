import 'dart:io';

import 'package:chatapp/src/features/auth/domain/entities/user_profile_entity.dart';
import 'package:chatapp/src/features/chats/domain/entities/chat_entity.dart';
import 'package:chatapp/src/features/chats/domain/entities/message_entity.dart';
import 'package:chatapp/src/features/chats/presentation/chat/bloc/sm.dart';
import 'package:equatable/equatable.dart';

abstract class ChatState extends Equatable {
  final ChatEntity? chat;
  final UserProfileEntity? userProfile;
  final Stream<List<MessageEntity>>? messagesStream;
  final Exception? exception;
  final MessageEntity? editingMessage;
  final File? file;
  final List<SM>? sending;

  const ChatState({
    this.chat,
    this.messagesStream,
    this.exception,
    this.userProfile,
    this.editingMessage,
    this.file,
    this.sending,
  });

  @override
  List<Object> get props => [
        chat!,
        userProfile!,
        messagesStream!,
        sending!,
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
    List<SM> sending,
  ) : super(
          chat: chat,
          messagesStream: messagesStream,
          userProfile: userProfileEntity,
          sending: sending,
        );
}

class ErrorChatState extends ChatState {
  const ErrorChatState(Exception exception) : super(exception: exception);
}

class EditingChatState extends ChatState {
  const EditingChatState(
    ChatEntity chat,
    Stream<List<MessageEntity>> messagesStream,
    UserProfileEntity userProfileEntity,
    MessageEntity editingMessage,
    List<SM> sending,
  ) : super(
          chat: chat,
          messagesStream: messagesStream,
          userProfile: userProfileEntity,
          editingMessage: editingMessage,
          sending: sending,
        );
}

class FileSelectedChatState extends ChatState {
  const FileSelectedChatState(
    ChatEntity chat,
    Stream<List<MessageEntity>> messagesStream,
    UserProfileEntity userProfileEntity,
    File file,
    List<SM> sending,
  ) : super(
          chat: chat,
          messagesStream: messagesStream,
          userProfile: userProfileEntity,
          file: file,
          sending: sending,
        );
}

class SendingMessageChatState extends ChatState {
  const SendingMessageChatState(
    ChatEntity chat,
    Stream<List<MessageEntity>> messagesStream,
    UserProfileEntity userProfileEntity,
    List<SM> sending,
  ) : super(
          chat: chat,
          messagesStream: messagesStream,
          userProfile: userProfileEntity,
          sending: sending,
        );
}
