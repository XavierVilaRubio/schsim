import 'package:flutter/material.dart';
import 'package:schsim/algorithms/dispacher.dart';
import 'package:schsim/algorithms/process.dart';

class ResultsScreen extends StatefulWidget {
  final int cpus;
  final List<int> arrivalTimeList;
  final List<String> jobBurstList;
  final String mode;
  final String algorithm;
  ResultsScreen(
      {Key key,
      @required this.cpus,
      @required this.arrivalTimeList,
      @required this.jobBurstList,
      @required this.mode,
      @required this.algorithm})
      : super(key: key);

  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  List<Widget> jobs() {
    List<Widget> list = [];
    for (int i = 0; i < widget.arrivalTimeList.length; i++) {
      list.add(Text(String.fromCharCode("A".codeUnitAt(0) + i) +
          ': ' +
          widget.arrivalTimeList[i].toString() +
          ': ' +
          widget.jobBurstList[i].toString()));
    }
    return list;
  }

  List<DataRow> jobsTable() {
    List<DataRow> list = [];
    for (int i = 0; i < widget.arrivalTimeList.length; i++) {
      list.add(DataRow(cells: [
        DataCell(Text(String.fromCharCode("A".codeUnitAt(0) + i))),
        DataCell(Text(widget.arrivalTimeList[i].toString())),
        DataCell(Text(widget.jobBurstList[i].toString())),
      ]));
    }
    return list;
  }

  List<int> results = [];

  List<Widget> resultats(List<int> results) {
    List<Widget> list = [];
    for (int i = 0; i < results.length - 1; i = i + 2) {
      list.add(Text((list.length + 1).toString() +
          ': ' +
          String.fromCharCode(results[i]) +
          ' (finished at ' +
          results[i + 1].toString() +
          ')'));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    Dispacher sim1 = Dispacher(
        cpus: widget.cpus,
        arrivalTimeList: widget.arrivalTimeList,
        jobBurstList: widget.jobBurstList,
        mode: widget.mode,
        algorithm: widget.algorithm);
    List<Process> processes =
        sim1.createProcesses(widget.arrivalTimeList, widget.jobBurstList);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('SCHSIM Results'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('CPUs: ${widget.cpus}'),
            Text('Jobs:'),
            DataTable(
              columns: [
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Arrival Time')),
                DataColumn(label: Text('Job Burst')),
              ],
              rows: processes
                  .map(
                    (process) => DataRow(cells: [
                      DataCell(Text(String.fromCharCode(process.name))),
                      DataCell(Text(process.arrivalTime.toString())),
                      DataCell(Text(process.jobBurst
                          .toString()
                          .replaceAll('[', '')
                          .replaceAll(']', ''))),
                    ]),
                  )
                  .toList(),
            ),
            Text('Mode: ${widget.mode}'),
            Text('Algorithm: ${widget.algorithm}'),
            RaisedButton(
              child: Text('RUN!'),
              onPressed: () {
                results = sim1.run();
                setState(() {});
              },
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: resultats(results),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
