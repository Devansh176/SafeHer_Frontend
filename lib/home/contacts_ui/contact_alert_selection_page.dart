import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home_ui/home_bloc/contacts/contacts_bloc.dart';

class ContactAlertSelectionPage extends StatefulWidget {
  const ContactAlertSelectionPage({super.key});

  @override
  State<ContactAlertSelectionPage> createState() => _ContactAlertSelectionPageState();
}

class _ContactAlertSelectionPageState extends State<ContactAlertSelectionPage> {
  List<Contact> selectedContacts = [];

  @override
  void initState() {
    super.initState();
    _loadPreviouslySelectedContacts();
    context.read<ContactsBloc>().add(LoadContactsEvent(selectedContacts: []));
  }

  Future<void> _loadPreviouslySelectedContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('alertContacts');
    if (jsonString != null && jsonString.isNotEmpty) {
      final List<dynamic> decoded = jsonDecode(jsonString);
      setState(() {
        selectedContacts = decoded.map((e) => Contact.fromJson(e)).toList();
      });
    }
  }

  void _toggleSelection(Contact contact) {
    setState(() {
      if (_isSelected(contact)) {
        selectedContacts.removeWhere((c) => c.id == contact.id);
      } else {
        selectedContacts.add(contact);
      }
    });
  }

  bool _isSelected(Contact contact) {
    return selectedContacts.any((c) => c.id == contact.id);
  }

  Future<void> _saveSelectedContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedContacts = jsonEncode(selectedContacts.map((c) => c.toJson()).toList());
    await prefs.setString('alertContacts', encodedContacts);
    Navigator.pop(context); // Go back to previous page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Alert Contacts"),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _saveSelectedContacts,
          ),
        ],
      ),
      body: BlocBuilder<ContactsBloc, ContactsState>(
        builder: (context, state) {
          if (state is ContactsLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ContactsLoaded) {
            final allContacts = state.contacts;
            return ListView.builder(
              itemCount: allContacts.length,
              itemBuilder: (context, index) {
                final contact = allContacts[index];
                final hasPhone = contact.phones.isNotEmpty;
                return CheckboxListTile(
                  title: Text(contact.displayName),
                  subtitle: Text(hasPhone ? contact.phones.first.number : "No number"),
                  value: _isSelected(contact),
                  onChanged: hasPhone ? (_) => _toggleSelection(contact) : null,
                );
              },
            );
          } else {
            return Center(child: Text("Failed to load contacts."));
          }
        },
      ),
    );
  }
}
