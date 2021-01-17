import 'dart:io';

import 'process.dart';
import 'dart:collection';

class Dispacher {
  int cpus;
  List<int> arrivalTimeList;
  List<String> jobBurstList;
  final bool mode;
  final String algorithm;
  final List<int> priorityList;
  List<Process> processes;
  int time;
  //Són llistes perque si no no les puc ordenar
  List<Process> preparats = [];
  List<Process> entradaSortida = [];
  Process running;
  Process originalProcess;
  var resultats;

  Dispacher({
    this.cpus,
    this.arrivalTimeList,
    this.jobBurstList,
    this.mode,
    this.algorithm,
    this.priorityList,
  });

  List<Process> createProcesses(List<int> arrivalTimeList,
      List<String> jobBurstList, List<int> priorityList) {
    List<Process> list = [];
    for (int i = 0; i < arrivalTimeList.length; i++) {
      list.add(
          Process(arrivalTimeList[i], jobBurstList[i], i, priorityList[i]));
    }
    return list;
  }

  void printHello() {
    processes.forEach((process) {
      print(process.getName() +
          ': ' +
          process.arrivalTime.toString() +
          ': ' +
          process.jobBurst.toString());
    });
    print('');
  }

  List<List<String>> run() {
    start();
    printHello();
    selectRunningProcess();
    for (time = 0; time < 25 && processes.isNotEmpty; time++) {
      addToPreparats();
      work();
    }
    for (int i = 0; i < resultats.length; i++) print(resultats[i]);
    return resultats;
  }

  void start() {
    processes = createProcesses(arrivalTimeList, jobBurstList, priorityList);
    resultats = List.generate(
        processes.length, (index) => List.generate(15, (index) => '0'));
    preparats.clear();
    running = null;
    originalProcess = null;
  }

  void addToPreparats() {
    processes.forEach((process) {
      //Mirem si han arribat nous processos.
      if (process.arrivalTime == time) preparats.add(process);
    });

    if (algorithm == 'SJF') {
      preparats.sort(
          (a, b) => a.originalJobBurst[0].compareTo(b.originalJobBurst[0]));
    } else if (algorithm == 'Priorities') {
      preparats.sort((a, b) => a.priority.compareTo(b.priority));
    }
  }

  void selectRunningProcess() {
    if (running == null && preparats.isNotEmpty) {
      running = preparats.removeAt(0);
      if (algorithm != 'FIFO' && mode) {
        if (originalProcess == null || originalProcess.name != running.name)
          originalProcess = Process.clone(running);
      }
      //running != null && preparats.isNotEmpty
    } else if (preparats.isNotEmpty && mode) {
      if (algorithm == 'SJF') {
        if (running.originalJobBurst[0] > preparats[0].originalJobBurst[0]) {
          preparats.add(running);
          running = preparats.removeAt(0);
          originalProcess = running;
        }
      } else if (algorithm == 'Priorities') {
        if (running.priority > preparats[0].priority &&
            resultats[preparats[0].name - "A".codeUnitAt(0)][time] != 'I') {
          resultats[running.name - "A".codeUnitAt(0)][time] = 'P';
          preparats.add(running);
          running = preparats.removeAt(0);
          originalProcess = running;
        }
      }
    }
  }

  void work() {
    preparats.forEach((process) {
      resultats[process.name - "A".codeUnitAt(0)][time] = "P";
    });

    Queue toRemove = new Queue();
    //Processem entrada-sortida
    entradaSortida.forEach((process) {
      //Ha acabat la ràfaga.
      resultats[process.name - "A".codeUnitAt(0)][time] = "I";
      if (process.work() == 0) {
        toRemove.add(process);
        preparats.add(process);
        //Refresquem la cua de preparats.
        addToPreparats();
        //if (running == null) selectRunningProcess();
      }
    });
    toRemove.forEach((process) => entradaSortida.remove(process));
    selectRunningProcess();

    //Processem el proces que s'està executant
    if (running != null) {
      switch (running.work()) {
        //Ha acabat la ràfaga.
        case -1:
          resultats[running.name - "A".codeUnitAt(0)][time] = "E";
          break;
        case 0:
          resultats[running.name - "A".codeUnitAt(0)][time] = "E";
          entradaSortida.add(running);
          running = null;
          break;

        //Ha acabat tot.
        case 1:
          resultats[running.name - "A".codeUnitAt(0)][time] = "E";
          resultats[running.name - "A".codeUnitAt(0)][time + 1] = "F";
          processes.remove(running);
          running = null;
          selectRunningProcess();
          break;
      }
    }
  }

  void printStatus() {
    if (processes.isEmpty) return;
    print("TIME: " + time.toString());
    processes.forEach((process) {
      if (preparats.contains(process))
        print(process.getName() + " preparat" + process.jobBurst.toString());
      else if (entradaSortida.contains(process))
        print(process.getName() +
            " entrada/sortida" +
            process.jobBurst.toString());
      else if (running == process)
        print(process.getName() +
            " running (remaining: " +
            process.jobBurst[0].toString() +
            ")" +
            process.jobBurst.toString());
    });
  }

/* List<int> run() {
	switch (this.algorithm) {
	  case 'FIFO':
		return this.fifo();
		break;
	  case 'SJF':
		return this.sjf();
		break;
	  case 'Round Robin':
		return this.roundRobin();
		break;
	  case 'Priorities':
		return this.priorities();
		break;
	}
  } */
}
