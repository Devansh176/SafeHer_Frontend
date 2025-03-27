part of 'contacts_bloc.dart';

abstract class ContactsEvent extends Equatable {
  const ContactsEvent();
  @override
  List<Object?> get props => [];
}

class LoadContactsEvent extends ContactsEvent {
  final List<Contact> selectedContacts;
  const LoadContactsEvent({required this.selectedContacts});

  @override
  List<Object?> get props => [selectedContacts];
}

class FetchSavedContactsEvent extends ContactsEvent {}

class SelectContactEvent extends ContactsEvent {
  final Contact contact;
  const SelectContactEvent({required this.contact});

  @override
  List<Object?> get props => [contact];
}

class RemoveContactEvent extends ContactsEvent {
  final Contact contact;
  const RemoveContactEvent({required this.contact});

  @override
  List<Object?> get props => [contact];
}
