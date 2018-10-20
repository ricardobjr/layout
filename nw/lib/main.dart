import 'package:flutter/material.dart';
import 'package:nw/chat_home.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Chat Translate System",
      theme: new ThemeData(
        primaryColor: Colors.blue,
        accentColor: Colors.blue,
      ),
      debugShowCheckedModeBanner: true,
      home: new ChatHome(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'), // English
        const Locale('he', 'IL'),
        const Locale('pt', 'BR'),
      ],
    );
  }
}
