import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_advanced/sms_advanced.dart';

import '../../../../../repositories/contacts_repository.dart';

void sendSmsToAlertContacts(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  String? contactsJson = prefs.getString('alertContacts');

  if (contactsJson == null || contactsJson.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("No alert contacts available! Add contacts first."),
      ),
    );
    return;
  }

  List<Contact> contacts = (jsonDecode(contactsJson) as List)
      .map((data) => ContactsRepository().contactFromJson(data))
      .toList();

  if (contacts.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("No alert contacts available! Add contacts first."),
      ),
    );
    return;
  }

  final status = await Permission.sms.request();
  if (!status.isGranted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("SMS Permission denied"),
      ),
    );
    return;
  }

  SmsSender sender = SmsSender();
  const String message = "Help me";

  for (var contact in contacts) {
    final phone = contact.phones.isNotEmpty ? contact.phones.first.number : "";
    if (phone.isNotEmpty) {
      SmsMessage sms = SmsMessage(phone, message);
      sms.onStateChanged.listen((state) {
        debugPrint('SMS to $phone changed state to: $state');
      });
      sender.sendSms(sms);
    }
  }

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Alert messages sent")),
  );
}
