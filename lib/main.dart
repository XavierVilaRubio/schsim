import 'package:flutter/material.dart';
import 'package:schsim/screens/formScreen.dart';
import 'package:schsim/screens/resultsScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SCHSIM',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        textTheme: TextTheme(bodyText2: TextStyle(fontSize: 16)),
      ),
      home: FormScreen(),
    );
  }
}
