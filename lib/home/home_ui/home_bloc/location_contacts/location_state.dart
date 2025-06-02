import 'package:equatable/equatable.dart';
import 'package:flutter_contacts/contact.dart';

abstract class LocationContactsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LocationContactsInitial extends LocationContactsState {}

class LocationContactsLoading extends LocationContactsState {}

class LocationContactsLoaded extends LocationContactsState {
  final List<Contact> contacts;
  LocationContactsLoaded(this.contacts);

  @override
  List<Object?> get props => [contacts];
}

class LocationContactsError extends LocationContactsState {
  final String message;
  LocationContactsError(this.message);

  @override
  List<Object?> get props => [message];
}

class LocationContactsSentSuccess extends LocationContactsState {}
