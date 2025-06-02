// import 'dart:async';
// import 'dart:convert';
// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter_contacts/flutter_contacts.dart';
// import 'package:meta/meta.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sms_advanced/sms_advanced.dart';
//
// part 'alert_event.dart';
// part 'alert_state.dart';
//
// class AlertBloc extends Bloc<AlertEvent, AlertState> {
//   AlertBloc() : super(AlertInitial()) {
//     on<FetchAlertContactsEvent>(_onFetchAlertContacts);
//     on<RemoveAlertContactEvent>(_onRemoveContact);
//     on<SaveAlertContactsEvent>(_onSaveContacts);
//     on<AlertRequest>(_onAlertRequest);
//   }
//
//
//   ////Fetch Contacts
//   FutureOr<void> _onFetchAlertContacts(
//       FetchAlertContactsEvent event, Emitter<AlertState> emit) async {
//     emit(AlertLoading());
//
//     final prefs = await SharedPreferences.getInstance();
//     final contactsJson = prefs.getString('alertContacts');
//
//     if (contactsJson == null || contactsJson.isEmpty) {
//       emit(const AlertLoaded(selectedContacts: []));
//       return;
//     }
//
//     try {
//       final List<Contact> contacts = (jsonDecode(contactsJson) as List)
//           .map((contactJson) => Contact.fromJson(contactJson))
//           .toList();
//
//       emit(AlertLoaded(selectedContacts: contacts));
//     } catch (e) {
//       emit(AlertError(errorMsg: "Failed to load alert contacts"));
//     }
//   }
//
//
//   ////Remove Contacts
//   FutureOr<void> _onRemoveContact(
//       RemoveAlertContactEvent event, Emitter<AlertState> emit) async {
//     final prefs = await SharedPreferences.getInstance();
//     final contactsJson = prefs.getString('alertContacts');
//
//     if (contactsJson == null || contactsJson.isEmpty) {
//       emit(const AlertLoaded(selectedContacts: []));
//       return;
//     }
//     List<Contact> contacts = (jsonDecode(contactsJson) as List)
//         .map((contactJson) => Contact.fromJson(contactJson))
//         .toList();
//
//     contacts.removeWhere((c) => c.id == event.contact.id);
//
//     await prefs.setString(
//         'alertContacts', jsonEncode(contacts.map((c) => c.toJson()).toList()));
//     emit(AlertLoaded(selectedContacts: contacts));
//   }
//
//
//   /////Save Contacts
//   FutureOr<void> _onSaveContacts(
//       SaveAlertContactsEvent event, Emitter<AlertState> emit) async {
//     final prefs = await SharedPreferences.getInstance();
//     final contactJsonList = event.contacts.map((c) => c.toJson()).toList();
//
//     await prefs.setString('alertContacts', jsonEncode(contactJsonList));
//     emit(AlertLoaded(selectedContacts: event.contacts));
//   }
//
//
//   ////Request Alert Contacts
//   FutureOr<void> _onAlertRequest(
//       AlertRequest event, Emitter<AlertState> emit) async {
//     emit(AlertLoading());
//
//     var status = await Permission.sms.request();
//     if (!status.isGranted) {
//       emit(AlertError(errorMsg: "SMS Permission Denied"));
//       return;
//     }
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final String? alertContactsJson = prefs.getString('alertContacts');
//       if (alertContactsJson == null || alertContactsJson.isEmpty) {
//         emit(AlertError(errorMsg: "No alert contacts found"));
//         return;
//       }
//       List<Contact> contacts = (jsonDecode(alertContactsJson) as List)
//           .map((contactJson) => Contact.fromJson(contactJson))
//           .toList();
//
//       final msg = event.msg;
//       SmsSender sender = SmsSender();
//
//       for (final contact in contacts) {
//         final number =
//         contact.phones.isNotEmpty ? contact.phones[0].number : "";
//         if (number.isNotEmpty) {
//           SmsMessage message = SmsMessage(number, msg);
//           sender.sendSms(message);
//         }
//       }
//       emit(AlertLoaded(selectedContacts: contacts));
//     } catch (e) {
//       emit(AlertError(errorMsg: "Failed to send messages"));
//     }
//   }
// }
