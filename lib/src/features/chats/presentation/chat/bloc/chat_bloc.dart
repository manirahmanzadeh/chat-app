import 'dart:async';

import 'package:chatapp/src/features/auth/domain/repository/auth_repository.dart';
import 'package:chatapp/src/features/chats/presentation/chat/bloc/chat_event.dart';
import 'package:chatapp/src/features/chats/presentation/chat/bloc/chat_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final AuthRepository _authRepository;

  User get currentUser => _authRepository.getCurrentUser()!;

  ChatBloc(this._authRepository) : super(const LoadingChatState()) {
    on<LoadChatEvent>(onLoadChat);
  }

  FutureOr<void> onLoadChat(LoadChatEvent event, Emitter<ChatState> emit) {
    emit(LoadedChatState(event.chat));
  }
}
