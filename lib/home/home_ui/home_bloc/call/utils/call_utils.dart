import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:safer/home/home_ui/home_bloc/call/call_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../repositories/contacts_repository.dart';

void showCallDialog(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  String? contactsJson = prefs.getString('selected_contacts');

  if(contactsJson == null || contactsJson.isEmpty){
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


  showDialog(
    context: context,
    builder: (dialogContext) => Builder(
      builder: (newContext) {
        return AlertDialog(
          title: Text("Select a contact to call"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: contacts.map((contact) {
                String phoneNumber = contact.phones.isNotEmpty ? contact.phones.first.number : "No Numbers available";
                return ListTile(
                  title: Text(contact.displayName),
                  subtitle: Text(phoneNumber),
                  onTap: () {
                    if(phoneNumber != "No Numbers available") {
                      makePhoneCall(phoneNumber);
                      Navigator.pop(newContext);
                      BlocProvider.of<CallBloc>(newContext).add(
                        CallRequest(phoneNumber: phoneNumber),
                      );
                    } else {
                      ScaffoldMessenger.of(newContext).showSnackBar(
                        SnackBar(
                          content: Text("No phone number available for ${contact.displayName}"),
                        ),
                      );
                    }
                  },
                );
              }).toList(),
            ),
          ),
        );
      }
    )
  );
}

Future<void> makePhoneCall(String phoneNumber) async {
  bool? callMade = await FlutterPhoneDirectCaller.callNumber(phoneNumber);
  if(callMade == false || callMade == null){
    debugPrint("Direct call failed, trying dialer...");
    final Uri callUri = Uri.parse("tel:$phoneNumber");
    if(await canLaunchUrl(callUri)){
      await launchUrl(callUri);
    } else {
      debugPrint("Could not launch dialer for $phoneNumber");
    }
  }
}