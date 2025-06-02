import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../home_ui/home_bloc/location_contacts/location_bloc.dart';
import '../home_ui/home_bloc/location_contacts/location_event.dart';
import '../home_ui/home_bloc/location_contacts/location_state.dart';

class ContactLocationSelectionPage extends StatefulWidget {
  const ContactLocationSelectionPage({super.key});

  @override
  State<ContactLocationSelectionPage> createState() => _ContactLocationSelectionPageState();
}

class _ContactLocationSelectionPageState extends State<ContactLocationSelectionPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LocationContactsBloc>().add(LoadLocationContactsEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Location Contacts")),
      body: BlocBuilder<LocationContactsBloc, LocationContactsState>(
        builder: (context, state) {
          if (state is LocationContactsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LocationContactsError) {
            return Center(child: Text(state.message));
          } else if (state is LocationContactsLoaded) {
            return ListView.builder(
              itemCount: state.contacts.length,
              itemBuilder: (context, index) {
                final contact = state.contacts[index];
                return ListTile(
                  title: Text(contact.displayName),
                  subtitle: Text(contact.phones.isNotEmpty ? contact.phones[0].number : "No number"),
                  onTap: () {
                    context.read<LocationContactsBloc>().add(SelectLocationContactEvent(contact: contact));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("${contact.displayName} added for location sharing")),
                    );
                  },
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
