import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:schsim/screens/resultsScreen.dart';

class FormScreen extends StatefulWidget {
  FormScreen({Key key}) : super(key: key);
  List<int> arrivalTimeList = [null];
  List<String> jobBurstList = [null];
  List<int> prioritiesList = [null];

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final GlobalKey<FormBuilderState> _globalKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _arrivalTimeController = TextEditingController();
  TextEditingController _jobBurstController = TextEditingController();
  TextEditingController _prioritiesController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _arrivalTimeController = TextEditingController();
    _jobBurstController = TextEditingController();
    _prioritiesController = TextEditingController();
  }

  @override
  void dispose() {
    _arrivalTimeController.dispose();
    _jobBurstController.dispose();
    _prioritiesController.dispose();
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
                padding: const EdgeInsets.all(24.0),
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
                                SizedBox(width: 30),
                                Expanded(
                                    flex: 2,
                                    child: Text(
                                      'Arrival Time',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[900]),
                                    )),
                                SizedBox(width: 5),
                                Expanded(
                                    flex: 2,
                                    child: Text(
                                      'Job Burst',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[900]),
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: Text(
                                      'Priority',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[900]),
                                    )),
                                SizedBox(
                                  width: 40,
                                )
                              ],
                            ),
                            ..._getJobs(),
                            Row(
                              children: [
                                Expanded(
                                  child: Center(
                                    child: RaisedButton(
                                      onPressed: () {
                                        widget.arrivalTimeList.insert(
                                            widget.arrivalTimeList.length,
                                            null);
                                        widget.jobBurstList.insert(
                                            widget.jobBurstList.length, null);
                                        widget.prioritiesList.insert(
                                            widget.prioritiesList.length, null);
                                        setState(() {});
                                      },
                                      child: Icon(Icons.add),
                                      color: Colors.green,
                                    ),
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
                        FormBuilderFieldOption(value: 'Preemptive'),
                        FormBuilderFieldOption(value: 'Non-Preemptive'),
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
                    Column(
                      children: [
                        SizedBox(height: 20),
                        Text(
                          'Quantum',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        FormBuilderTextField(
                          attribute: 'quantum',
                          validators: [FormBuilderValidators.required()],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
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
                  mode: (_globalKey.currentState.value['mode'].toString() ==
                          'Preemptive')
                      ? true
                      : false,
                  algorithm:
                      _globalKey.currentState.value['algorithm'].toString(),
                  prioritiesList: widget.prioritiesList,
                  quantum: int.parse(_globalKey.currentState.value['quantum']),
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
                    child: JobTextFields(i, widget.arrivalTimeList,
                        widget.jobBurstList, widget.prioritiesList)),
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
          widget.prioritiesList.removeAt(index);
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
  final List<int> prioritiesList;

  JobTextFields(
      this.index, this.arrivalTimeList, this.jobBurstList, this.prioritiesList);

  @override
  _JobTextFieldsState createState() => _JobTextFieldsState();
}

class _JobTextFieldsState extends State<JobTextFields> {
  TextEditingController _arrivalTimeController;
  TextEditingController _jobBurstController;
  TextEditingController _prioritiesController;

  @override
  void initState() {
    super.initState();
    _arrivalTimeController = TextEditingController();
    _jobBurstController = TextEditingController();
    _prioritiesController = TextEditingController();
  }

  @override
  void dispose() {
    _arrivalTimeController.dispose();
    _jobBurstController.dispose();
    _prioritiesController.dispose();
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

      if (widget.prioritiesList[widget.index] == null)
        _prioritiesController.text = '';
      else
        _prioritiesController.text =
            widget.prioritiesList[widget.index].toString();
    });
    return Row(
      children: [
        Text(
          String.fromCharCode("A".codeUnitAt(0) + widget.index),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 20),
        Flexible(
          flex: 2,
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
          flex: 2,
          child: TextFormField(
            controller: _jobBurstController,
            onChanged: (jobBurst) =>
                widget.jobBurstList[widget.index] = jobBurst,
            decoration: InputDecoration(
                hintText: 'Job Burst (3, 2, 3 = 3CPU, 2E/S, 3CPU)'),
            keyboardType: TextInputType.number,
            validator: (jobBurst) {
              if (jobBurst.trim().isEmpty) {
                return 'Please enter something';
              }
              return null;
            },
          ),
        ),
        SizedBox(width: 20),
        Flexible(
          flex: 1,
          child: TextFormField(
            controller: _prioritiesController,
            onChanged: (priority) =>
                widget.prioritiesList[widget.index] = int.parse(priority),
            decoration: InputDecoration(hintText: 'Priority'),
            keyboardType: TextInputType.number,
            validator: (priority) {
              if (priority.trim().isEmpty) {
                return 'Please enter something';
              } else if (int.parse(priority) < 1 || int.parse(priority) > 9) {
                return 'Please priority has to be between 1 and 9';
              } else if (dupilcated(widget.prioritiesList)) {
                return 'You can\'t repeat priorities';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  bool dupilcated(List<int> list) {
    bool dup = false;
    Map map = new Map();
    list.forEach((x) => map[x] = !map.containsKey(x) ? (1) : (map[x] + 1));
    print(map);
    map.forEach((key, value) {
      if (map[key] > 1) dup = true;
    });
    print(dup);
    return dup;
  }
}
