import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:xml/xml.dart';

class Contact {
  final String fullName;
  final String email;
  final bool favourite;

  Contact({required this.fullName, required this.email, required this.favourite});
}

class JsonContactApi {
  final String _jsonContactString = '''
  {
    "contacts": [
      {
        "fullName": "John Doe (JSON)",
        "email": "johndoe@json.com",
        "favourite": true
      },
      {
        "fullName": "Emma Doe (JSON)",
        "email": "emmadoe@json.com",
        "favourite": false
      },
      {
        "fullName": "Michael Roe (JSON)",
        "email": "michaelroe@json.com",
        "favourite": false
      }
    ]
  }
  ''';

  String getContactsjson() {
    return _jsonContactString;
  }
}

class XmlContactApi {
  final String _xmlContactString = '''
  <?xml version="1.0"?>
  <contacts>
    <contact>
      <fullname>John Doe (XML)</fullname>
      <email>johndoe@xml.com</email>
      <favourite>false</favourite>
    </contact>
    <contact>
      <fullname>Emma Doe (XML)</fullname>
      <email>emmadoe@xml.com</email>
      <favourite>true</favourite>
    </contact>
    <contact>
      <fullname>Michael Roe (XML)</fullname>
      <email>michaelroe@xml.com</email>
      <favourite>true</favourite>
    </contact>
  </contacts>
  ''';

  String getContactsxml() {
    return _xmlContactString;
  }
}

abstract class IContactsAdapter {
  List<Contact> getContacts();
}

class JsonContactAdapter implements IContactsAdapter {
  JsonContactApi jsonContactApi = JsonContactApi();

  @override
  List<Contact> getContacts() {
    return _parseContactJson(jsonContactApi.getContactsjson());
  }

  List<Contact> _parseContactJson(String contactJson) {
    final contactsMap = json.decode(contactJson) as Map<String, dynamic>;
    final contactsJsonList = contactsMap['contacts'] as List;
    final contactsList = contactsJsonList.map((json) {
      final contactJson = json as Map<String, dynamic>;

      return Contact(
        fullName: contactJson['fullName'] as String,
        email: contactJson['email'] as String,
        favourite: contactJson['favourite'] as bool,
      );
    }).toList();

    return contactsList;
  }
}

class XmlContactAdapter implements IContactsAdapter {
  XmlContactApi xmlContactApi = XmlContactApi();
  @override
  List<Contact> getContacts() {
    return _parseContactsXml(xmlContactApi._xmlContactString);
  }

  List<Contact> _parseContactsXml(String contactsXml) {
    final xmlDocument = XmlDocument.parse(contactsXml);

    final contactsList = <Contact>[];

    for (final xmlElement in xmlDocument.findAllElements('contact')) {
      final fullName = xmlElement.findElements('fullname').single.text;
      final email = xmlElement.findElements('email').single.text;
      final favouriteString = xmlElement.findElements('favourite').single.text;
      final favourite = favouriteString.toLowerCase() == 'true';

      contactsList.add(Contact(
        fullName: fullName,
        email: email,
        favourite: favourite,
      ));
    }

    return contactsList;
  }
}

class AdapterView extends StatefulWidget {
  AdapterView({Key? key}) : super(key: key);

  @override
  State<AdapterView> createState() => _AdapterViewState();
}

class _AdapterViewState extends State<AdapterView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ContactsSection(
              adapter: JsonContactAdapter(),
              headerText: 'Contacts from JSON API:',
            ),
            const SizedBox(height: 10),
            ContactsSection(
              adapter: XmlContactAdapter(),
              headerText: 'Contacts from XML API:',
            ),
          ],
        ),
      ),
    );
  }
}

class ContactsSection extends StatelessWidget {
  final IContactsAdapter adapter;
  final String headerText;
  const ContactsSection({Key? key, required this.adapter, required this.headerText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(headerText),
          for (var contact in adapter.getContacts())
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: ContactCard(
                contact: contact,
              ),
            )
        ],
      ),
    );
  }
}

class ContactCard extends StatelessWidget {
  final Contact contact;

  const ContactCard({
    required this.contact,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(contact.fullName),
        subtitle: Text(contact.email),
        leading: CircleAvatar(
          backgroundColor: Colors.grey,
          foregroundColor: Colors.white,
          child: Text(contact.fullName[0]),
        ),
        trailing: Icon(
          contact.favourite ? Icons.star : Icons.star_border,
        ),
      ),
    );
  }
}
