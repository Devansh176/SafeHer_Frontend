import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../home_ui/home_bloc/contacts/contacts_bloc.dart';
import 'contact_call_selection_page.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ContactsBloc>().add(FetchSavedContactsEvent());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Contacts to Call"),
        actions: [
          IconButton(                                         
            icon: const Icon(Icons.add_circle_outline_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ContactSelectionPage()),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<ContactsBloc, ContactsState>(
        builder: (context, state) {
          if (state is ContactsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ContactsLoaded) {
            if (state.selectedContacts.isEmpty) {
              return const Center(child: Text("No contacts selected"));
            }
            return ListView.builder(
              itemCount: state.selectedContacts.length,
              itemBuilder: (context, index) {
                final contact = state.selectedContacts[index];
                return ListTile(
                  title: Text(contact.displayName),
                  subtitle: Text(contact.phones.isNotEmpty ? contact.phones[0].number : "No Number"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      context.read<ContactsBloc>().add(RemoveContactEvent(contact: contact));
                    },
                  ),
                );
              },
            );
          } else if (state is ContactsError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text("Unexpected error occurred"));
        },
      ),
    );
  }
}
