import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:schsim/widgets/jobsForm.dart';
import 'package:schsim/screens/resultsScreen.dart';

class FormScreen extends StatefulWidget {
  FormScreen({Key key}) : super(key: key);

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final GlobalKey<FormBuilderState> _globalKey = GlobalKey<FormBuilderState>();
  Future<void> _showData() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Obtained parameters'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text('Nº of cpus: ' +
                      _globalKey.currentState.value['cpus'].round().toString()),
                  Text('Arrival time: $_arrivalTimeList'),
                  Text('Job Burst: $_jobBurstList'),
                  Text('Mode: ' +
                      _globalKey.currentState.value['mode'].toString()),
                  Text('Algorithm: ' +
                      _globalKey.currentState.value['algorithm'].toString()),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  static List<String> _arrivalTimeList = [null];
  static List<String> _jobBurstList = [null];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("SCHSIM Form"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FormBuilder(
              key: _globalKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Nº of cpus',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    FormBuilderSlider(
                      name: 'cpus',
                      min: 1,
                      max: 5,
                      initialValue: 3,
                      divisions: 4,
                      numberFormat: NumberFormat("0", "en_US"),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Nº of jobs',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    JobsForm(
                      arrivalTimeList: _arrivalTimeList,
                      jobBurstList: _jobBurstList,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Mode',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    FormBuilderRadioGroup(
                      name: 'mode',
                      options: [
                        FormBuilderFieldOption(value: 'Preemtive'),
                        FormBuilderFieldOption(value: 'Non-Preemtive'),
                      ],
                      wrapAlignment: WrapAlignment.spaceEvenly,
                      validator: FormBuilderValidators.required(context),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Algorithm',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    FormBuilderDropdown(
                      name: 'algorithm',
                      items: ['FIFO', 'SJF', 'Round Robin', 'Priorities']
                          .map((algorithm) => DropdownMenuItem(
                              value: algorithm, child: Text("$algorithm")))
                          .toList(),
                      validator: FormBuilderValidators.required(context),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                  child: Text("Reset"),
                  onPressed: () {
                    _globalKey.currentState.reset();
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward),
        onPressed: () {
          _globalKey.currentState.save();
          if (_globalKey.currentState.validate()) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ResultsScreen(
                        cpus: _globalKey.currentState.value['cpus']
                            .round()
                            .toString(),
                        arrivalTimeList: _arrivalTimeList,
                        jobBurstList: _jobBurstList,
                        mode: _globalKey.currentState.value['mode'].toString(),
                        algorithm: _globalKey.currentState.value['algorithm']
                            .toString(),
                      )),
            );
            print('arrivalTime: $_arrivalTimeList');
            print('jobBurst: $_jobBurstList');
          }
        },
      ),
    );
  }
}
