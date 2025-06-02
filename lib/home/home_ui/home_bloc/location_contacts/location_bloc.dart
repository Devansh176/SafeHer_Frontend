import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sms_advanced/sms_advanced.dart';

import 'location_event.dart';
import 'location_state.dart';

class LocationContactsBloc extends Bloc<LocationContactsEvent, LocationContactsState> {
  List<Contact> selectedContacts = [];

  LocationContactsBloc() : super(LocationContactsInitial()) {
    on<LoadLocationContactsEvent>(_onLoadContacts);
    on<SelectLocationContactEvent>(_onSelectContact);
    on<RemoveLocationContactEvent>(_onRemoveContact);
    on<SendLocationToContacts>(_onSendContacts);
  }

  void _onLoadContacts(
      LoadLocationContactsEvent event, Emitter<LocationContactsState> emit) {
    emit(LocationContactsLoaded(selectedContacts));
  }

  void _onSelectContact(
      SelectLocationContactEvent event, Emitter<LocationContactsState> emit) {
    if (!selectedContacts.contains(event.contact)) {
      selectedContacts.add(event.contact);
    }
    emit(LocationContactsLoaded(selectedContacts));
  }

  void _onRemoveContact(
      RemoveLocationContactEvent event, Emitter<LocationContactsState> emit) {
    selectedContacts.remove(event.contact);
    emit(LocationContactsLoaded(selectedContacts));
  }

  Future<void> _onSendContacts(
      SendLocationToContacts event, Emitter<LocationContactsState> emit) async {
    try {
      // Get current location
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      String locationUrl =
          "https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}";

      // Send SMS to each contact
      for (var contact in selectedContacts) {
        for (var phone in contact.phones) {
          await _sendSMS("Emergency! Here's my location: $locationUrl", phone.number);
        }
      }

      emit(LocationContactsSentSuccess());
    } catch (e) {
      emit(LocationContactsError("Failed to send contacts: ${e.toString()}"));
    }
  }

  Future<void> _sendSMS(String message, String recipient) async {
    SmsSender sender = SmsSender();
    SmsMessage sms = SmsMessage(recipient, message);
    sender.sendSms(sms);
  }
}
