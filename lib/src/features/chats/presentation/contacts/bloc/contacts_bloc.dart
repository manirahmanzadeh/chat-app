import 'package:chatapp/src/features/chats/domain/usecases/get_contacts_usecase.dart';
import 'package:chatapp/src/features/chats/presentation/contacts/bloc/contacts_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'contacts_state.dart';

class ContactsBloc extends Bloc<ContactEvent, ContactsState> {
  final GetContactsUseCase _getContactsUseCase;

  ContactsBloc(this._getContactsUseCase) : super(const LoadingContactsState()) {
    on<GetContactsContactEvent>(onGetChats);
  }

  void onGetChats(GetContactsContactEvent event, Emitter<ContactsState> emit) async {
    emit(
      const LoadingContactsState(),
    );
    try {
      final contactsStream = _getContactsUseCase();
      emit(LoadedContactsState(contactsStream));
    } on Exception catch (e) {
      emit(
        ErrorContactsState(e),
      );
    }
  }
}
