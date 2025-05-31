import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../home_ui/home_bloc/alert/alert_bloc.dart';
import 'contact_alert_selection_page.dart';

class AlertContactsPage extends StatelessWidget {
  const AlertContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AlertBloc>().add(FetchAlertContactsEvent());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Contacts to Alert"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ContactAlertSelectionPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<AlertBloc, AlertState>(
        builder: (context, state) {
          if (state is AlertLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AlertLoaded) {
            if (state.selectedContacts.isEmpty) {
              return const Center(child: Text("No alert contacts selected"));
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
                      context.read<AlertBloc>().add(RemoveAlertContactEvent(contact: contact));
                    },
                  ),
                );
              },
            );
          } else if (state is AlertError) {
            return Center(child: Text(state.errorMsg));
          }
          return const Center(child: Text("Unexpected error occurred"));
        },
      ),
    );
  }
}
