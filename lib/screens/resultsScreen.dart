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

  List<Widget> _buildCells(List<List<String>> results, int i,
      [int limit = -1]) {
    limit = (limit == -1) ? results[i].length : limit;
    List<Widget> list = List.generate(
      limit,
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

  List<TableRow> _resultats(List<List<String>> results, [int limit = -1]) {
    List<TableRow> list = List.generate(
        results.length,
        (index1) => TableRow(
              children: _buildCells(results, index1, limit),
            ));
    return list;
  }

  int length = -1;
  bool booleano = false;

  List<Widget> _buildMetrics(Dispacher dispacher) {
    List<Widget> metrics = [];
    int temps = (results[0].length - 1);
    int tCpuOcupada = 0;
    int numProcessos = widget.arrivalTimeList.length;
    List<int> tEspera = List.generate(numProcessos, (index) => 0);
    List<int> f = List.generate(numProcessos, (index) => 0);
    List<int> tRetornm = List.generate(numProcessos, (index) => 0);
    for (int i = 0; i < results.length; i++) {
      for (int j = 0; j < results[0].length; j++) {
        switch (results[i][j]) {
          case 'E':
            tCpuOcupada++;
            break;
          case 'P':
            tEspera[i]++;
            break;
          case 'F':
            f[i] = j;
        }
      }
    }
    List<int> tRetorn = List.generate(
        numProcessos, (index) => (f[index] - widget.arrivalTimeList[index]));
    List<int> totalJobBurst = dispacher.getTotalJobBurst();
    List<double> tRetornN = List.generate(
        numProcessos, (index) => (tRetorn[index] / totalJobBurst[index]));
    metrics.add(
      Text('Utilització CPU = ' +
          tCpuOcupada.toString() +
          ' / ' +
          temps.toString() +
          ' = ' +
          (tCpuOcupada / temps).toString() +
          ' = ' +
          ((tCpuOcupada / temps) * 100).toString() +
          '%'),
    );
    metrics.add(
      Text('Productivitat = ' +
          numProcessos.toString() +
          ' / ' +
          temps.toString() +
          ' = ' +
          (numProcessos / temps).toStringAsFixed(2)),
    );
    print('tEspera: ' + tEspera.toString());
    metrics.add(
      Text('Tespera mitjà = ' +
          tEspera.reduce((a, b) => a + b).toString() +
          ' / ' +
          numProcessos.toString() +
          ' = ' +
          (tEspera.reduce((a, b) => a + b) / numProcessos).toStringAsFixed(2)),
    );
    print('tRetorn: ' + tRetorn.toString());
    metrics.add(
      Text('Tretorn mitjà = ' +
          tRetorn.reduce((a, b) => a + b).toString() +
          ' / ' +
          numProcessos.toString() +
          ' = ' +
          (tRetorn.reduce((a, b) => a + b) / numProcessos).toStringAsFixed(2)),
    );
    print('tRetorn: ' + tRetorn.toString());
    print('totalJobBurst: ' + totalJobBurst.toString());
    print('tRetornN: ' + tRetornN.toString());
    metrics.add(
      Text('TretornN mitjà = ' +
          tRetornN.reduce((a, b) => a + b).toString() +
          ' / ' +
          numProcessos.toString() +
          ' = ' +
          (tRetornN.reduce((a, b) => a + b) / numProcessos).toStringAsFixed(2)),
    );
    return metrics;
  }

  List<Widget> metricList = [];

  @override
  Widget build(BuildContext context) {
    Dispacher dispacher = Dispacher(
        cpus: widget.cpus,
        arrivalTimeList: widget.arrivalTimeList,
        jobBurstList: widget.jobBurstList,
        mode: widget.mode,
        algorithm: widget.algorithm,
        priorityList: widget.prioritiesList,
        quantum: widget.quantum);
    List<Process> processes = dispacher.createProcesses(
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
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Container(),
                ),
                RaisedButton(
                  child: Text('RUN!'),
                  onPressed: () {
                    results = dispacher.run();
                    booleano = true;
                    length = -1;
                    metricList = _buildMetrics(dispacher);
                    setState(() {});
                  },
                ),
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                RaisedButton(
                  child: Text('Reset'),
                  onPressed: () {
                    results = [];
                    length = -1;
                    setState(() {});
                  },
                ),
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                RaisedButton(
                  child: Text('Step By Step'),
                  onPressed: () {
                    length = (length == -1) ? 0 : length++;
                    results = dispacher.run(length);
                    //length++;
                    setState(() {});
                  },
                ),
                Expanded(
                  flex: 5,
                  child: Container(),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Table(
              border: TableBorder.all(
                  color: Colors.black, style: BorderStyle.solid, width: 1),
              defaultColumnWidth: FixedColumnWidth(40),
              children: _resultats(results, length),
            ),
            SizedBox(
              height: 20,
            ),
            (length != -1)
                ? Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Container(),
                      ),
                      RaisedButton(
                        child: Icon(Icons.arrow_back),
                        onPressed: () {
                          length = (length > 0) ? length - 1 : length;
                          results = dispacher.run();
                          setState(() {});
                        },
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(),
                      ),
                      RaisedButton(
                        child: Icon(Icons.arrow_forward),
                        onPressed: () {
                          length = (length < results[0].length)
                              ? length + 1
                              : length;
                          results = dispacher.run();
                          setState(() {});
                        },
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(),
                      ),
                    ],
                  )
                : Container(),
            ...metricList
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
