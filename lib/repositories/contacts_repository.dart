import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ContactsRepository {
  Future<List<Contact>> fetchAllContacts() async {
    if (await FlutterContacts.requestPermission()) {
      final contacts = await FlutterContacts.getContacts(withProperties: true);
      return contacts;
    }
    throw Exception("Permission denied");
  }

  Future<void> saveSelectedContacts(List<Contact> contacts) async {
    final prefs = await SharedPreferences.getInstance();
    final contactsJson = jsonEncode(contacts.map((c) => _contactToJson(c)).toList());
    await prefs.setString('selected_contacts', contactsJson);
  }

  Future<List<Contact>> getSelectedContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final contactsJson = prefs.getString('selected_contacts');
    if (contactsJson == null) return [];
    final List<dynamic> decoded = jsonDecode(contactsJson);
    return decoded.map((data) => _contactFromJson(data)).toList();
  }

  Map<String, dynamic> _contactToJson(Contact contact) {
    return {
      'id': contact.id,
      'displayName': contact.displayName,
      'phones': contact.phones.map((phone) => phone.number).toList(),
    };
  }

  Contact _contactFromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'],
      displayName: json['displayName'],
      phones: (json['phones'] as List<dynamic>).map((phone) => Phone(phone)).toList(),
    );
  }
}
