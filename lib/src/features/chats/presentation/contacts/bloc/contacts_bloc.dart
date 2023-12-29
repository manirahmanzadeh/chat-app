import 'package:chatapp/src/features/chats/domain/usecases/get_contacts_usecase.dart';
import 'package:chatapp/src/features/chats/presentation/contacts/bloc/contacts_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'contacts_state.dart';

class ContactsBloc extends Bloc<ContactEvent, ContactsState> {
  final GetContactsUseCase _getContactsUseCase;

  ContactsBloc(this._getContactsUseCase) : super(const LoadingContactsState()) {
    on<GetContactsContactEvent>(onGetContacts);
  }

  void onGetContacts(GetContactsContactEvent event, Emitter<ContactsState> emit) async {
    emit(
      const LoadingContactsState(),
    );
    try {
      print('getting contacts');
      final contacts = await _getContactsUseCase();
      emit(LoadedContactsState(contacts));
    } on Exception catch (e) {
      emit(
        ErrorContactsState(e),
      );
    }
  }
}
