import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  final Exception? exception;

  const AuthState({this.exception});

  @override
  List<Object?> get props => [exception!];
}

class LoadingAuthState extends AuthState {
  const LoadingAuthState();
}

class LoadedAuthState extends AuthState {
  const LoadedAuthState();
}

class ErrorAuthState extends AuthState {
  const ErrorAuthState(Exception exception) : super(exception: exception);
}
