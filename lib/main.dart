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
      /* home: ResultsScreen(
        cpus: 3,
        arrivalTimeList: [4, 2, 2],
        jobBurstList: ['2,2,1', '3', '2'],
        mode: true,
        algorithm: 'Round Robin',
        prioritiesList: [1, 2, 3],
        quantum: 2,
      ), */
    );
  }
}
