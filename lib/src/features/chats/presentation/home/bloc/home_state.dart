import 'package:chatapp/src/features/chats/domain/entities/chat_entity.dart';
import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  final Stream<List<ChatEntity>>? chatsStream;
  final Exception? exception;

  const HomeState({this.chatsStream, this.exception});

  @override
  List<Object> get props => [chatsStream!, exception!];
}

class LoadingHomeState extends HomeState {
  const LoadingHomeState();
}

class LoadedHomeState extends HomeState {
  const LoadedHomeState(Stream<List<ChatEntity>> chatsStream) : super(chatsStream: chatsStream);
}

class ErrorHomeState extends HomeState {
  const ErrorHomeState(Exception exception) : super(exception: exception);
}
