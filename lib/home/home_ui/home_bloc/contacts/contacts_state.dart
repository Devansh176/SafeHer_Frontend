part of 'contacts_bloc.dart';

abstract class ContactsState extends Equatable {
  const ContactsState();
  @override
  List<Object?> get props => [];
}

class ContactsInitial extends ContactsState {}

class ContactsLoading extends ContactsState {}

class ContactsLoaded extends ContactsState {
  final List<Contact> contacts;
  final List<Contact> selectedContacts;

  const ContactsLoaded({required this.contacts, required this.selectedContacts});

  @override
  List<Object?> get props => [contacts, selectedContacts];
}

class ContactsError extends ContactsState {
  final String message;
  const ContactsError(this.message);

  @override
  List<Object?> get props => [message];
}
