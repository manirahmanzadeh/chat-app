import 'package:chatapp/src/features/auth/data/data_sources/firebase_auth_service.dart';
import 'package:chatapp/src/features/chats/domain/usecases/get_chats_usecase.dart';
import 'package:chatapp/src/features/chats/presentation/home/bloc/home_event.dart';
import 'package:chatapp/src/features/chats/presentation/home/bloc/home_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetChatsUseCase _getChatsUseCase;
  final FirebaseAuthService _firebaseAuthService;

  User get currentUser => _firebaseAuthService.currentUser!;

  HomeBloc(this._getChatsUseCase, this._firebaseAuthService) : super(const LoadingHomeState()) {
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
}
