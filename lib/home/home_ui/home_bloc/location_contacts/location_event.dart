import 'package:flutter_contacts/contact.dart';

abstract class LocationContactsEvent {}

class LoadLocationContactsEvent extends LocationContactsEvent {}

class SelectLocationContactEvent extends LocationContactsEvent {
  final Contact contact;
  SelectLocationContactEvent({required this.contact});
}

class RemoveLocationContactEvent extends LocationContactsEvent {
  final Contact contact;
  RemoveLocationContactEvent({required this.contact});
}

class SendLocationToContacts extends LocationContactsEvent {}
