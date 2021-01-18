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
      debugShowCheckedModeBanner: false,
      title: 'SCHSIM',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        textTheme: TextTheme(bodyText2: TextStyle(fontSize: 16)),
      ),
      //home: FormScreen(),
      home: ResultsScreen(
        cpus: 3,
        arrivalTimeList: [0, 2, 3],
        jobBurstList: ['7', '4', '2'],
        mode: true,
        algorithm: 'FIFO',
        prioritiesList: [1, 2, 3],
        quantum: 2,
      ),
    );
  }
}
