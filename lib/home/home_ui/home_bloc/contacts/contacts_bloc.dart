import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../repositories/contacts_repository.dart';

part 'contacts_event.dart';
part 'contacts_state.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  final ContactsRepository _contactsRepository;

  ContactsBloc(this._contactsRepository) : super(ContactsInitial()) {
    on<LoadContactsEvent>(_onLoadContacts);
    on<FetchSavedContactsEvent>(_onFetchSavedContacts);
    on<SelectContactEvent>(_onSelectContact);
    on<RemoveContactEvent>(_onRemoveContact);
  }

  FutureOr<void> _onLoadContacts(LoadContactsEvent event, Emitter<ContactsState> emit) async {
    emit(ContactsLoading());
    print("Loading contacts from phone...");
    try {
      if (await Permission.contacts.request().isGranted) {
        final allContacts = await _contactsRepository.fetchAllContacts();
        print("Fetched ${allContacts.length} contacts from phone.");
        emit(ContactsLoaded(contacts: allContacts, selectedContacts: event.selectedContacts));
      } else {
        emit(ContactsError("Permission denied"));
      }
    } catch (e) {
      emit(ContactsError("Error fetching contacts: ${e.toString()}"));
    }
  }

  FutureOr<void> _onFetchSavedContacts(FetchSavedContactsEvent event, Emitter<ContactsState> emit) async {
    try {
      final savedContacts = await _contactsRepository.getSelectedContacts();
      print("Loaded ${savedContacts.length} saved contacts.");
      emit(ContactsLoaded(contacts: [], selectedContacts: savedContacts));
    } catch (e) {
      emit(ContactsError("Error loading saved contacts: ${e.toString()}"));
    }
  }

  FutureOr<void> _onSelectContact(SelectContactEvent event, Emitter<ContactsState> emit) async {
    if (state is ContactsLoaded) {
      final currentState = state as ContactsLoaded;
      final updatedSelected = List<Contact>.from(currentState.selectedContacts);
      if (!updatedSelected.contains(event.contact)) {
        updatedSelected.add(event.contact);
      }
      await _contactsRepository.saveSelectedContacts(updatedSelected);
      emit(ContactsLoaded(contacts: currentState.contacts, selectedContacts: updatedSelected));
    }
  }

  FutureOr<void> _onRemoveContact(RemoveContactEvent event, Emitter<ContactsState> emit) async {
    if (state is ContactsLoaded) {
      final currentState = state as ContactsLoaded;
      final updatedSelected = List<Contact>.from(currentState.selectedContacts)..remove(event.contact);
      await _contactsRepository.saveSelectedContacts(updatedSelected);
      emit(ContactsLoaded(contacts: currentState.contacts, selectedContacts: updatedSelected));
    }
  }
}
