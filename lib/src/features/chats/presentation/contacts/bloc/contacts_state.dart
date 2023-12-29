import 'package:chatapp/src/features/auth/domain/entities/user_profile_entity.dart';
import 'package:equatable/equatable.dart';

abstract class ContactsState extends Equatable {
  final List<UserProfileEntity>? contacts;
  final Exception? exception;

  const ContactsState({this.contacts, this.exception});

  @override
  List<Object> get props => [contacts!, exception!];
}

class LoadingContactsState extends ContactsState {
  const LoadingContactsState();
}

class LoadedContactsState extends ContactsState {
  const LoadedContactsState(List<UserProfileEntity> contacts) : super(contacts: contacts);
}

class ErrorContactsState extends ContactsState {
  const ErrorContactsState(Exception exception) : super(exception: exception);
}
