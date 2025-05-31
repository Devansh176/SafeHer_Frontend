import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import '../home_ui/home_bloc/contacts/contacts_bloc.dart';

class ContactSelectionPage extends StatefulWidget {
  const ContactSelectionPage({super.key});

  @override
  _ContactSelectionPageState createState() => _ContactSelectionPageState();
}

class _ContactSelectionPageState extends State<ContactSelectionPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentState = context.read<ContactsBloc>().state;
      List<Contact> previouslySelected = [];
      if (currentState is ContactsLoaded) {
        previouslySelected = currentState.selectedContacts;
      }
      context.read<ContactsBloc>().add(LoadContactsEvent(selectedContacts: previouslySelected));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Contacts"),
      ),
      body: BlocBuilder<ContactsBloc, ContactsState>(
        builder: (context, state) {
          if (state is ContactsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ContactsError) {
            return Center(child: Text(state.message));
          } else if (state is ContactsLoaded) {
            if (state.contacts.isEmpty) {
              return const Center(child: Text("No contacts found on device"));
            }
            return ListView.builder(
              itemCount: state.contacts.length,
              itemBuilder: (context, index) {
                final contact = state.contacts[index];
                return ListTile(
                  title: Text(contact.displayName),
                  subtitle: Text(contact.phones.isNotEmpty ? contact.phones[0].number : "No Number"),
                  onTap: () {
                    context.read<ContactsBloc>().add(SelectContactEvent(contact: contact));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("${contact.displayName} added")),
                    );
                  },
                );
              },
            );
          }
          return const Center(child: Text("Unexpected error occurred"));
        },
      ),
    );
  }
}
