import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:schsim/screens/resultsScreen.dart';

class FormScreen extends StatefulWidget {
  FormScreen({Key key}) : super(key: key);
  List<int> arrivalTimeList = [null];
  List<String> jobBurstList = [null];

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final GlobalKey<FormBuilderState> _globalKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _arrivalTimeController = TextEditingController();
  TextEditingController _jobBurstController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _arrivalTimeController = TextEditingController();
    _jobBurstController = TextEditingController();
  }

  @override
  void dispose() {
    _arrivalTimeController.dispose();
    _jobBurstController.dispose();
    super.dispose();
  }

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
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(width: 25),
                                Expanded(
                                    child: Text(
                                  'Arrival Time',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[900]),
                                )),
                                Expanded(
                                    child: Text(
                                  'Job Burst',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[900]),
                                )),
                                SizedBox(width: 30)
                              ],
                            ),
                            ..._getJobs(),
                            Row(
                              children: [
                                FlatButton(
                                  onPressed: () {
                                    widget.arrivalTimeList = [null];
                                    widget.jobBurstList = [null];
                                    setState(() {});
                                    print('reset');
                                  },
                                  child: Text('Reset'),
                                  color: Colors.red[300],
                                ),
                                Flexible(
                                  child: Container(),
                                ),
                                Container(
                                  child: RaisedButton(
                                    onPressed: () {
                                      widget.arrivalTimeList.insert(
                                          widget.arrivalTimeList.length, null);
                                      widget.jobBurstList.insert(
                                          widget.jobBurstList.length, null);
                                      setState(() {});
                                    },
                                    child: Icon(Icons.add),
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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
          _formKey.currentState.save();
          if (_formKey.currentState.validate() &&
              _globalKey.currentState.validate()) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResultsScreen(
                  cpus: _globalKey.currentState.value['cpus'].round(),
                  arrivalTimeList: widget.arrivalTimeList,
                  jobBurstList: widget.jobBurstList,
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

  List<Widget> _getJobs() {
    List<Widget> jobsRowsList = [];
    if (widget.arrivalTimeList.length == widget.jobBurstList.length) {
      for (int i = 0; i < widget.arrivalTimeList.length; i++) {
        jobsRowsList.add(
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              children: [
                Expanded(
                    child: JobTextFields(
                        i, widget.arrivalTimeList, widget.jobBurstList)),
                SizedBox(width: 16),
                _addRemoveButton(i != 0, i),
              ],
            ),
          ),
        );
      }
    }
    return jobsRowsList;
  }

  Widget _addRemoveButton(bool add, int index) {
    if (add) {
      return InkWell(
        onTap: () {
          widget.arrivalTimeList.removeAt(index);
          widget.jobBurstList.removeAt(index);
          setState(() {});
        },
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Icon(
            Icons.remove,
            color: Colors.white,
          ),
        ),
      );
    } else {
      return Container(
        height: 30,
        width: 30,
      );
    }
  }
}

class JobTextFields extends StatefulWidget {
  final int index;
  final List<int> arrivalTimeList;
  final List<String> jobBurstList;

  JobTextFields(this.index, this.arrivalTimeList, this.jobBurstList);

  @override
  _JobTextFieldsState createState() => _JobTextFieldsState();
}

class _JobTextFieldsState extends State<JobTextFields> {
  TextEditingController _arrivalTimeController;
  TextEditingController _jobBurstController;

  @override
  void initState() {
    super.initState();
    _arrivalTimeController = TextEditingController();
    _jobBurstController = TextEditingController();
  }

  @override
  void dispose() {
    _arrivalTimeController.dispose();
    _jobBurstController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.arrivalTimeList[widget.index] == null)
        _arrivalTimeController.text = '';
      else
        _arrivalTimeController.text =
            widget.arrivalTimeList[widget.index].toString();
      if (widget.jobBurstList[widget.index] == null)
        _jobBurstController.text = '';
      else
        _jobBurstController.text = widget.jobBurstList[widget.index].toString();
    });
    return Row(
      children: [
        Text(
          String.fromCharCode("A".codeUnitAt(0) + widget.index),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 20),
        Flexible(
          child: TextFormField(
            controller: _arrivalTimeController,
            onChanged: (time) =>
                widget.arrivalTimeList[widget.index] = int.parse(time),
            decoration: InputDecoration(hintText: 'Arrival Time'),
            keyboardType: TextInputType.number,
            validator: (time) {
              if (time.trim().isEmpty) {
                return 'Please enter something';
              } else if (int.parse(time) < 0) {
                return 'Please Arrival Time can\'t be negative';
              }
              return null;
            },
          ),
        ),
        SizedBox(width: 20),
        Flexible(
          child: TextFormField(
            controller: _jobBurstController,
            onChanged: (jobBurst) =>
                widget.jobBurstList[widget.index] = jobBurst,
            decoration: InputDecoration(hintText: 'Job Burst'),
            keyboardType: TextInputType.number,
            validator: (jobBurst) {
              if (jobBurst.trim().isEmpty) {
                return 'Please enter something';
              } else if (int.parse(jobBurst) < 0) {
                return 'Please Arrival Time can\'t be negative';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
