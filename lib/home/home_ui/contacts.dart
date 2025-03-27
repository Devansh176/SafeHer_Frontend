import 'package:flutter/material.dart';

class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  List<String> contacts = ["+911234567890", "+919876543210"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts to Call"),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline_rounded),
            onPressed: () {}
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(contacts[index]),
            trailing: IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.green,
              ),
              onPressed: () {
              },
            ),
          );
        },
      ),
    );
  }
}
