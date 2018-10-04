import 'package:flutter/material.dart';
import 'package:nw/whatsapp_home.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "WhatsApp",
      theme: new ThemeData(
        primaryColor: Colors.blue,
        accentColor: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: new WhatsAppHome(),
    );
  }
}
