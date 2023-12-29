import 'package:chatapp/src/features/chats/domain/usecases/create_chat_usecase.dart';
import 'package:chatapp/src/features/chats/domain/usecases/get_contacts_usecase.dart';
import 'package:chatapp/src/features/chats/presentation/chat/chat_screen.dart';
import 'package:chatapp/src/features/chats/presentation/contacts/bloc/contacts_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'contacts_state.dart';

class ContactsBloc extends Bloc<ContactEvent, ContactsState> {
  final GetContactsUseCase _getContactsUseCase;
  final CreateChatUseCase _createChatUseCase;
  late BuildContext _context;

  addContext(BuildContext context) {
    _context = context;
  }

  ContactsBloc(
    this._getContactsUseCase,
    this._createChatUseCase,
  ) : super(const LoadingContactsState()) {
    on<GetContactsContactEvent>(onGetContacts);
    on<CreateChatContactsEvent>(onCreateChat);
  }

  Future<void> onGetContacts(GetContactsContactEvent event, Emitter<ContactsState> emit) async {
    emit(
      const LoadingContactsState(),
    );
    try {
      final contacts = await _getContactsUseCase();
      emit(LoadedContactsState(contacts));
    } on Exception catch (e) {
      emit(
        ErrorContactsState(e),
      );
    }
  }

  Future<void> onCreateChat(CreateChatContactsEvent event, Emitter<ContactsState> emit) async {
    emit(
      const LoadingContactsState(),
    );
    try {
      await _createChatUseCase(params: event.targetUser);
      Navigator.pushNamed(_context, ChatScreen.routeName);
      emit(LoadedContactsState(event.loadedProfiles));
    } on Exception catch (e) {
      emit(
        ErrorContactsState(e),
      );
    }
  }
}
