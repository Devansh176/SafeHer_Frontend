import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import '../home_ui/home_bloc/contacts/contacts_bloc.dart';

class ContactLocationPage extends StatefulWidget {
  const ContactLocationPage({super.key});

  @override
  State<ContactLocationPage> createState() => _ContactLocationPageState();
}

class _ContactLocationPageState extends State<ContactLocationPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<ContactsBloc>().state;
      List<Contact> previouslySelected = [];
      if (state is ContactsLoaded) {
        previouslySelected = state.selectedContacts;
      }
      context.read<ContactsBloc>().add(
        LoadContactsEvent(selectedContacts: previouslySelected),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Contacts")),
      body: BlocBuilder<ContactsBloc, ContactsState>(
        builder: (context, state) {
          if (state is ContactsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ContactsError) {
            return Center(child: Text(state.message));
          } else if (state is ContactsLoaded) {
            final contacts = state.contacts;
            if (contacts.isEmpty) {
              return const Center(child: Text("No contacts found"));
            }
            return ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return ListTile(
                  title: Text(contact.displayName),
                  subtitle: Text(contact.phones.isNotEmpty
                      ? contact.phones[0].number
                      : "No Number"),
                  onTap: () {
                    context
                        .read<ContactsBloc>()
                        .add(SelectContactEvent(contact: contact));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("${contact.displayName} added"),
                      ),
                    );
                  },
                );
              },
            );
          }
          return const Center(child: Text("Unexpected error"));
        },
      ),
    );
  }
}
