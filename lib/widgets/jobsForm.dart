import 'package:flutter/material.dart';

class JobsForm extends StatefulWidget {
  List<String> arrivalTimeList;
  List<String> jobBurstList;
  JobsForm(
      {Key key, @required this.arrivalTimeList, @required this.jobBurstList})
      : super(key: key);

  @override
  _JobsFormState createState() => _JobsFormState();
}

class _JobsFormState extends State<JobsForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
    return Container(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ..._getJobs(),
              SizedBox(height: 40),
              Row(
                children: [
                  /*
                  Expanded(
                    child: FlatButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          print('arrivalTimeList: $arrivalTimeList');
                          print('jobBurstList: $jobBurstList');
                        }
                      },
                      child: Text('Submit'),
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(width: 30),
                  */
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
                ],
              ),
            ],
          ),
        ),
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
                _addRemoveButton(i == 0, i),
              ],
            ),
          ),
        );
      }
    } else {
      print('ERROR');
    }
    return jobsRowsList;
  }

  Widget _addRemoveButton(bool add, int index) {
    return InkWell(
      onTap: () {
        print('$add, $index');
        if (add) {
          widget.arrivalTimeList.insert(widget.arrivalTimeList.length, null);
          widget.jobBurstList.insert(widget.jobBurstList.length, null);
        } else {
          widget.arrivalTimeList.removeAt(index);
          widget.jobBurstList.removeAt(index);
        }
        setState(() {});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }
}

class JobTextFields extends StatefulWidget {
  final int index;
  final List<String> arrivalTimeList;
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
      _arrivalTimeController.text = widget.arrivalTimeList[widget.index] ?? '';
      _jobBurstController.text = widget.jobBurstList[widget.index] ?? '';
    });
    return Row(
      children: [
        Flexible(
          child: TextFormField(
            controller: _arrivalTimeController,
            onChanged: (time) => widget.arrivalTimeList[widget.index] = time,
            decoration: InputDecoration(hintText: 'Arrival Time'),
            keyboardType: TextInputType.number,
            validator: (time) {
              if (time.trim().isEmpty) return 'Please enter something';
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
              if (jobBurst.trim().isEmpty) return 'Please enter something';
              return null;
            },
          ),
        ),
      ],
    );
  }
}
