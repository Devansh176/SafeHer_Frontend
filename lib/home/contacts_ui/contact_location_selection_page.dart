import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../home_ui/home_bloc/contacts/contacts_bloc.dart';
import '../home_ui/home_bloc/location/location_sharing_bloc.dart';
import 'contact_call_selection_page.dart';

class SelectedLocationContactsPage extends StatelessWidget {
  const SelectedLocationContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Sharing Contacts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => const ContactSelectionPage(),
              ));
            },
          )
        ],
      ),
      body: BlocBuilder<ContactsBloc, ContactsState>(
        builder: (context, state) {
          if (state is ContactsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ContactsError) {
            return Center(child: Text(state.message));
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
                  subtitle: Text(contact.phones.isNotEmpty
                      ? contact.phones[0].number
                      : 'No number'),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle),
                    onPressed: () {
                      context.read<ContactsBloc>().add(
                        RemoveContactEvent(contact: contact),
                      );
                    },
                  ),
                );
              },
            );
          }
          return const Center(child: Text("Unexpected error"));
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final state = context.read<ContactsBloc>().state;
          if (state is ContactsLoaded) {
            context.read<LocationSharingBloc>().add(
              ShareLocationEvent(selectedContacts: state.selectedContacts),
            );
          }
        },
        label: const Text("Share Live Location"),
        icon: const Icon(Icons.location_on),
      ),
    );
  }
}
