import 'package:chatapp/src/features/auth/domain/entities/user_profile_entity.dart';
import 'package:equatable/equatable.dart';

abstract class ContactsState extends Equatable {
  final Stream<List<UserProfileEntity>>? contactsStream;
  final Exception? exception;

  const ContactsState({this.contactsStream, this.exception});

  @override
  List<Object> get props => [contactsStream!, exception!];
}

class LoadingContactsState extends ContactsState {
  const LoadingContactsState();
}

class LoadedContactsState extends ContactsState {
  const LoadedContactsState(Stream<List<UserProfileEntity>> contactsStream) : super(contactsStream: contactsStream);
}

class ErrorContactsState extends ContactsState {
  const ErrorContactsState(Exception exception) : super(exception: exception);
}
