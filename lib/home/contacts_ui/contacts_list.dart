// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../home_ui/home_bloc/contacts/contacts_bloc.dart';
//
// class ContactsListPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Select Contacts")),
//       body: BlocBuilder<ContactsBloc, ContactsState>(
//         builder: (context, state) {
//           if (state is ContactsLoading) {
//             return Center(child: CircularProgressIndicator());
//           } else if (state is ContactsLoaded) {
//             return ListView.builder(
//               itemCount: state.contacts.length,
//               itemBuilder: (context, index) {
//                 return CheckboxListTile(
//                   title: Text(state.contacts[index].displayName),
//                   value: false,
//                   onChanged: (selected) {
//                     if (selected == true) {
//                       context.read<ContactsBloc>().add(SelectContact(state.contacts[index]));
//                     }
//                   },
//                 );
//               },
//             );
//           }
//           return Center(child: Text("No Contacts Found"));
//         },
//       ),
//     );
//   }
// }
