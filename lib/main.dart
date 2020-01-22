import 'package:flutter/material.dart';
import 'package:gps_app/src/pages/home_page.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'home',
      routes: {
        'home': (BuildContext ctx) => HomePage(),
      },
    );
  }
}
