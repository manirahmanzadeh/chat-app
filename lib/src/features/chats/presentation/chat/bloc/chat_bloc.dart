import 'dart:async';

import 'package:chatapp/src/features/auth/domain/repository/auth_repository.dart';
import 'package:chatapp/src/features/chats/domain/entities/chat_entity.dart';
import 'package:chatapp/src/features/chats/domain/usecases/get_messages_usecase.dart';
import 'package:chatapp/src/features/chats/domain/usecases/send_message_usecase.dart';
import 'package:chatapp/src/features/chats/presentation/chat/bloc/chat_event.dart';
import 'package:chatapp/src/features/chats/presentation/chat/bloc/chat_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final AuthRepository _authRepository;
  final GetMessagesUseCase _getMessagesUseCase;
  final SendMessageUseCase _sendMessageUseCase;

  late ChatEntity _chat;

  User get currentUser => _authRepository.getCurrentUser()!;

  ChatBloc(
    this._authRepository,
    this._getMessagesUseCase,
    this._sendMessageUseCase,
  ) : super(const LoadingChatState()) {
    on<LoadChatEvent>(onLoadChat);
    on<SendMessageChatEvent>(onSendMessage);
  }

  FutureOr<void> onLoadChat(LoadChatEvent event, Emitter<ChatState> emit) {
    emit(
      const LoadingChatState(),
    );
    try {
      final messagesStream = _getMessagesUseCase(params: event.chat.chatId);
      _chat = event.chat;
      emit(LoadedChatState(event.chat, messagesStream));
    } on Exception catch (e) {
      emit(
        ErrorChatState(e),
      );
    }
  }

  FutureOr<void> onSendMessage(SendMessageChatEvent event, Emitter<ChatState> emit) async {
    try {
      await _sendMessageUseCase(params: {
        'chatId': _chat.chatId,
        'senderUid': currentUser.uid,
        'text': event.text,
      });
    } on Exception catch (e) {
      emit(
        ErrorChatState(e),
      );
    }
  }
}
