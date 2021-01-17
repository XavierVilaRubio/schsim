import 'package:flutter/material.dart';
import 'package:schsim/algorithms/dispacher.dart';
import 'package:schsim/algorithms/process.dart';

class ResultsScreen extends StatefulWidget {
  final int cpus;
  final List<int> arrivalTimeList;
  final List<String> jobBurstList;
  final bool mode;
  final String algorithm;
  final List<int> prioritiesList;
  ResultsScreen(
      {Key key,
      @required this.cpus,
      @required this.arrivalTimeList,
      @required this.jobBurstList,
      @required this.mode,
      @required this.algorithm,
      @required this.prioritiesList})
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
        DataCell(Text(widget.prioritiesList[i].toString()))
      ]));
    }
    return list;
  }

  List<List<String>> results = [];

  Color _getColor(String s) {
    switch (s) {
      case 'E':
        return Colors.green;
        break;
      case 'P':
        return Colors.orange;
        break;
      case 'F':
        return Colors.red;
        break;
      case 'I':
        return Colors.blue;
        break;
      default:
        return Colors.transparent;
        break;
    }
  }

  List<Widget> _buildCells(List<List<String>> results, int i) {
    return List.generate(
      results[i].length,
      (index) => Container(
        alignment: Alignment.center,
        width: 20,
        height: 20,
        color: _getColor(results[i][index]),
        child: Text(results[i][index]),
      ),
    );
  }

  List<TableRow> _resultats(List<List<String>> results) {
    return List.generate(
        results.length,
        (index1) => TableRow(
              children: List.generate(
                results[index1].length,
                (index2) => Container(
                  alignment: Alignment.center,
                  width: 20,
                  height: 20,
                  color: _getColor(results[index1][index2]),
                  child: Text((results[index1][index2] != '0')
                      ? results[index1][index2]
                      : ''),
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    Dispacher sim1 = Dispacher(
        cpus: widget.cpus,
        arrivalTimeList: widget.arrivalTimeList,
        jobBurstList: widget.jobBurstList,
        mode: widget.mode,
        algorithm: widget.algorithm,
        priorityList: widget.prioritiesList);
    List<Process> processes = sim1.createProcesses(
        widget.arrivalTimeList, widget.jobBurstList, widget.prioritiesList);

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
                DataColumn(label: Text('Priority'))
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
                      DataCell(Text(process.priority.toString()))
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
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Table(
                  border: TableBorder.all(
                      color: Colors.black, style: BorderStyle.solid, width: 2),
                  defaultColumnWidth: FixedColumnWidth(20),
                  children: _resultats(results),
                )),
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
