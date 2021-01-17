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
  final int quantum;
  ResultsScreen(
      {Key key,
      @required this.cpus,
      @required this.arrivalTimeList,
      @required this.jobBurstList,
      @required this.mode,
      @required this.algorithm,
      @required this.prioritiesList,
      this.quantum})
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

  String _getMode() {
    if (widget.mode) {
      return 'Preemptive';
    } else {
      return 'Non-Preemptive';
    }
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
      case 'W':
        return Colors.blue;
        break;
      default:
        return Colors.transparent;
        break;
    }
  }

  List<Widget> _buildCells(List<List<String>> results, int i) {
    List<Widget> list = List.generate(
      results[i].length,
      (index) => Container(
        alignment: Alignment.center,
        width: 40,
        height: 40,
        color: _getColor(results[i][index]),
        child: Text(
          results[i][index],
          style: (results[i][index] == 'E' ||
                  results[i][index] == 'P' ||
                  results[i][index] == 'F' ||
                  results[i][index] == 'W')
              ? TextStyle(fontWeight: FontWeight.bold)
              : TextStyle(),
        ),
      ),
    );
    list.insert(
        0,
        Container(
          alignment: Alignment.center,
          width: 40,
          height: 40,
          child: Text(
            String.fromCharCode("A".codeUnitAt(0) + i),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ));
    return list;
  }

  List<TableRow> _resultats(List<List<String>> results) {
    List<TableRow> list = List.generate(
        results.length,
        (index1) => TableRow(
              children: _buildCells(results, index1),
            ));
    /*
    list.insert(
        0,
        TableRow(
            children: List<Widget>.generate(
                results[0].length,
                (index) => Container(
                      alignment: Alignment.center,
                      width: 40,
                      height: 40,
                      child: Text(
                        'o',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ))));*/
    return list;
  }

  @override
  Widget build(BuildContext context) {
    Dispacher sim1 = Dispacher(
        cpus: widget.cpus,
        arrivalTimeList: widget.arrivalTimeList,
        jobBurstList: widget.jobBurstList,
        mode: widget.mode,
        algorithm: widget.algorithm,
        priorityList: widget.prioritiesList,
        quantum: widget.quantum);
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
            Text('Mode: ' + _getMode()),
            Text('Algorithm: ${widget.algorithm}'),
            (widget.algorithm == 'Round Robin')
                ? Text('Quantum: ${widget.quantum}')
                : Container(),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              child: Text('RUN!'),
              onPressed: () {
                results = sim1.run();
                setState(() {});
              },
            ),
            SizedBox(
              height: 30,
            ),
            Table(
              border: TableBorder.all(
                  color: Colors.black, style: BorderStyle.solid, width: 1),
              defaultColumnWidth: FixedColumnWidth(40),
              children: _resultats(results),
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
