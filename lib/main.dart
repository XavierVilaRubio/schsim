import 'package:flutter/material.dart';
import 'package:schsim/screens/formScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SCHSIM',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: FormScreen(),
    );
  }
}
