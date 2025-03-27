// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_contacts/flutter_contacts.dart';
//
// import '../home_ui/home_bloc/contacts/contacts_bloc.dart';
//
// class ContactTile extends StatelessWidget {
//   final Contact contact;
//   final bool isSelected;
//
//   const ContactTile({super.key, required this.contact, required this.isSelected});
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       title: Text(contact.displayName),
//       subtitle: Text(contact.phones.isNotEmpty ? contact.phones.first.number : "No phone number"),
//       trailing: IconButton(
//         icon: Icon(isSelected ? Icons.check_circle : Icons.add_circle_outline, color: Colors.green),
//         onPressed: () {
//           if (isSelected) {
//             context.read<ContactsBloc>().add(RemoveContact(contact));
//           } else {
//             context.read<ContactsBloc>().add(SelectContact(contact));
//           }
//         },
//       ),
//     );
//   }
// }
