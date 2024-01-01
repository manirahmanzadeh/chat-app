import 'dart:async';

import 'package:chatapp/src/features/auth/domain/entities/user_profile_entity.dart';
import 'package:chatapp/src/features/auth/domain/repository/auth_repository.dart';
import 'package:chatapp/src/features/chats/domain/entities/chat_entity.dart';
import 'package:chatapp/src/features/chats/domain/entities/message_entity.dart';
import 'package:chatapp/src/features/chats/domain/usecases/delete_message_usecase.dart';
import 'package:chatapp/src/features/chats/domain/usecases/edit_message_usecase.dart';
import 'package:chatapp/src/features/chats/domain/usecases/get_messages_usecase.dart';
import 'package:chatapp/src/features/chats/domain/usecases/send_message_usecase.dart';
import 'package:chatapp/src/features/chats/presentation/chat/bloc/chat_event.dart';
import 'package:chatapp/src/features/chats/presentation/chat/bloc/chat_state.dart';
import 'package:chatapp/src/features/chats/presentation/contact/contact_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final AuthRepository _authRepository;
  final GetMessagesUseCase _getMessagesUseCase;
  final SendMessageUseCase _sendMessageUseCase;
  final DeleteMessageUseCase _deleteMessageUseCase;
  final EditMessageUseCase _editMessageUseCase;

  late BuildContext _context;
  late ChatEntity _chat;
  late Stream<List<MessageEntity>> _messageStream;
  late UserProfileEntity _userProfile;
  MessageEntity? _targetMessage;

  final TextEditingController messageController = TextEditingController();

  User get currentUser => _authRepository.getCurrentUser()!;

  ChatBloc(
    this._authRepository,
    this._getMessagesUseCase,
    this._sendMessageUseCase,
    this._deleteMessageUseCase,
    this._editMessageUseCase,
  ) : super(const LoadingChatState()) {
    on<LoadChatEvent>(onLoadChat);
    on<SendMessageChatEvent>(onSendMessage);
    on<DeleteMessageChatEvent>(onDeleteMessage);
    on<OpenEditingChatEvent>(onOpenEditing);
    on<CloseTargetMessageChatEvent>(onCloseTargetMessage);
    on<EditMessageChatEvent>(onEditMessage);
  }

  setContext(BuildContext context) {
    _context = context;
  }

  deleteMessage(String messageId) {
    add(DeleteMessageChatEvent(messageId));
  }

  openEditMessage(MessageEntity message) {
    _targetMessage = message;
    add(OpenEditingChatEvent(_targetMessage!));
  }

  closeTargetMessage() {
    add(const CloseTargetMessageChatEvent());
    _targetMessage = null;
    messageController.clear();
  }

  submitEditMessage() {
    add(const EditMessageChatEvent());
  }

  FutureOr<void> onLoadChat(LoadChatEvent event, Emitter<ChatState> emit) {
    emit(
      const LoadingChatState(),
    );
    try {
      final messagesStream = _getMessagesUseCase(params: event.chat.chatId);
      _chat = event.chat;
      _userProfile = event.userProfile;
      _messageStream = messagesStream;
      emit(LoadedChatState(_chat, _messageStream, _userProfile));
    } on Exception catch (e) {
      emit(
        ErrorChatState(e),
      );
    }
  }

  FutureOr<void> onSendMessage(SendMessageChatEvent event, Emitter<ChatState> emit) async {
    try {
      String message = messageController.text.trim();
      if (message.isNotEmpty) {
        _sendMessageUseCase(params: {
          'chatId': _chat.chatId,
          'senderUid': currentUser.uid,
          'text': message,
        });
        messageController.clear();
      }
    } on Exception catch (e) {
      emit(
        ErrorChatState(e),
      );
    }
  }

  FutureOr<void> onDeleteMessage(DeleteMessageChatEvent event, Emitter<ChatState> emit) async {
    try {
      await _deleteMessageUseCase(params: {
        'chatId': _chat.chatId,
        'messageId': event.messageId,
      });
    } on Exception catch (e) {
      emit(
        ErrorChatState(e),
      );
    }
  }

  FutureOr<void> onOpenEditing(OpenEditingChatEvent event, Emitter<ChatState> emit) {
    messageController.value = TextEditingValue(text: event.editingMessage.text);
    emit(
      EditingChatState(
        _chat,
        _messageStream,
        _userProfile,
        event.editingMessage,
      ),
    );
  }

  FutureOr<void> onCloseTargetMessage(CloseTargetMessageChatEvent event, Emitter<ChatState> emit) {
    emit(LoadedChatState(_chat, _messageStream, _userProfile));
  }

  FutureOr<void> onEditMessage(EditMessageChatEvent event, Emitter<ChatState> emit) async {
    try {
      String newText = messageController.text.trim();
      if (newText.isNotEmpty) {
        _editMessageUseCase(params: {
          'chatId': _chat.chatId,
          'messageId': _targetMessage!.messageId,
          'newText': newText,
        });
        emit(LoadedChatState(_chat, _messageStream, _userProfile));
        _targetMessage = null;
        messageController.clear();
      }
    } on Exception catch (e) {
      emit(
        ErrorChatState(e),
      );
    }
  }

  void goToContact() {
    Navigator.pushNamed(_context, ContactScreen.routeName, arguments: _userProfile);
  }
}
