import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../repositories/contacts_repository.dart';

void showContactSelectionBottomSheet(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  String? contactsJson = prefs.getString('selected_contacts');

  if (contactsJson == null || contactsJson.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("No contacts available! Add contacts first."),
      ),
    );
    return;
  }

  List<Contact> contacts = (jsonDecode(contactsJson) as List)
      .map((data) => ContactsRepository().contactFromJson(data))
      .toList();

  if (contacts.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("No contacts available! Add contacts first."),
      ),
    );
    return;
  }

  Contact firstContact = contacts.first;
  String phoneNumber = firstContact.phones.isNotEmpty ? firstContact.phones.first.number : "";

  if(phoneNumber.isNotEmpty) {
    makePhoneCall(phoneNumber);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("No phone number available for ${firstContact.displayName}"),
      ),
    );
  }
}

Future<void> makePhoneCall(String phoneNumber) async {
  bool? callMade = await FlutterPhoneDirectCaller.callNumber(phoneNumber);
  if (callMade == false || callMade == null) {
    debugPrint("Direct call failed, trying dialer...");
    final Uri callUri = Uri.parse("tel:$phoneNumber");
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      debugPrint("Could not launch dialer for $phoneNumber");
    }
  }
}
