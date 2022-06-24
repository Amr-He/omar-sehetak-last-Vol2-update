import 'package:flutter/material.dart';
import 'package:mb_contact_form/mb_contact_form.dart';


class Contact extends StatefulWidget {
  const Contact({Key key}) : super(key: key);

  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(" Contact ",style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            fontFamily: 'sans-serif-light',
            color: Colors.black),),
        elevation: 0,
      ),
      body:  const MBContactForm(
        hasHeading: false,
        withIcons: false,
        destinationEmail: "email@gmail.com",
      ),
    );
  }
}