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
  final GlobalKey<FormState> _jobsKey = GlobalKey<FormState>();

  static List<int> _arrivalTimeList = [null];
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    FormBuilderSlider(
                      attribute: 'cpus',
                      min: 1,
                      max: 5,
                      initialValue: 3,
                      divisions: 4,
                      numberFormat: NumberFormat("0", "en_US"),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Nº of jobs',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    JobsForm(
                      arrivalTimeList: _arrivalTimeList,
                      jobBurstList: _jobBurstList,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Mode',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    FormBuilderRadioGroup(
                      attribute: 'mode',
                      options: [
                        FormBuilderFieldOption(value: 'Preemtive'),
                        FormBuilderFieldOption(value: 'Non-Preemtive'),
                      ],
                      wrapAlignment: WrapAlignment.spaceEvenly,
                      validators: [FormBuilderValidators.required()],
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Algorithm',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    FormBuilderDropdown(
                      attribute: 'algorithm',
                      items: ['FIFO', 'SJF', 'Round Robin', 'Priorities']
                          .map((algorithm) => DropdownMenuItem(
                              value: algorithm, child: Text("$algorithm")))
                          .toList(),
                      validators: [FormBuilderValidators.required()],
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
                  key: _jobsKey,
                  cpus: _globalKey.currentState.value['cpus'].round(),
                  arrivalTimeList: _arrivalTimeList,
                  jobBurstList: _jobBurstList,
                  mode: _globalKey.currentState.value['mode'].toString(),
                  algorithm:
                      _globalKey.currentState.value['algorithm'].toString(),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
