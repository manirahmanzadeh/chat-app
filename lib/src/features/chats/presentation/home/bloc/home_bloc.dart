import 'package:chatapp/src/features/auth/domain/repository/auth_repository.dart';
import 'package:chatapp/src/features/chats/domain/entities/chat_entity.dart';
import 'package:chatapp/src/features/chats/domain/usecases/get_chats_usecase.dart';
import 'package:chatapp/src/features/chats/presentation/chat/chat_screen.dart';
import 'package:chatapp/src/features/chats/presentation/home/bloc/home_event.dart';
import 'package:chatapp/src/features/chats/presentation/home/bloc/home_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  late BuildContext _context;
  final GetChatsUseCase _getChatsUseCase;
  final AuthRepository _authRepository;

  User get currentUser => _authRepository.getCurrentUser()!;

  addContext(BuildContext context) {
    _context = context;
  }

  HomeBloc(this._getChatsUseCase, this._authRepository) : super(const LoadingHomeState()) {
    on<GetChatsHomeEvent>(onGetChats);
  }

  void onGetChats(GetChatsHomeEvent event, Emitter<HomeState> emit) async {
    emit(
      const LoadingHomeState(),
    );
    try {
      final chatsStream = _getChatsUseCase();
      emit(LoadedHomeState(chatsStream));
    } on Exception catch (e) {
      emit(
        ErrorHomeState(e),
      );
    }
  }

  goToChat(ChatEntity chat) {
    Navigator.pushNamed(_context, ChatScreen.routeName, arguments: chat);
  }
}
