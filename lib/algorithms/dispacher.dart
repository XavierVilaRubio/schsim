import 'dart:io';

import 'process.dart';
import 'dart:collection';
import 'dart:core';

class Dispacher {
  int cpus;
  List<int> arrivalTimeList;
  List<String> jobBurstList;
  final bool mode;
  final String algorithm;
  final List<int> priorityList;
  int quantum;
  List<Process> processes;
  int time = 0;
  int originalQuantum;
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
    this.quantum,
  });

  List<int> getTotalJobBurst() {
    processes = createProcesses(arrivalTimeList, jobBurstList, priorityList);
    List<int> totalJobBurst = List.generate(processes.length, (index) => 0);
    for (int i = 0; i < processes.length; i++) {
      totalJobBurst[i] = processes[i].jobBurst.reduce((a, b) => a + b);
    }
    return totalJobBurst;
  }

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

  List<List<String>> run([int limit = 50]) {
    start();
    printHello();
    selectRunningProcess();
    for (time = 0; time < 50 && processes.isNotEmpty; time++) {
      addToPreparats();
      work();
    }
    for (int i = 0; i < resultats.length; i++) {
      resultats[i] = resultats[i].sublist(0, time + 1);
      print(resultats[i]);
    }
    return resultats;
  }

  void start() {
    processes = createProcesses(arrivalTimeList, jobBurstList, priorityList);
    resultats = List.generate(processes.length,
        (index) => List.generate(50, (index) => index.toString()));
    originalQuantum = quantum;
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
      switch (algorithm) {
        case 'SJF':
          if (running.originalJobBurst[0] > preparats[0].originalJobBurst[0]) {
            preparats.add(running);
            running = preparats.removeAt(0);
            originalProcess = running;
          }
          break;
        case 'Priorities':
          if (running.priority > preparats[0].priority &&
              resultats[preparats[0].name - "A".codeUnitAt(0)][time] != 'W') {
            resultats[running.name - "A".codeUnitAt(0)][time] = 'P';
            preparats.add(running);
            running = preparats.removeAt(0);
            originalProcess = running;
          }
          break;
        case 'Round Robin':
          if (quantum == 0) {
            resultats[running.name - "A".codeUnitAt(0)][time] = 'P';
            preparats.add(running);
            running = preparats.removeAt(0);
            quantum = originalQuantum;
          }
          break;
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
      resultats[process.name - "A".codeUnitAt(0)][time] = "W";
      if (process.work() == 0) {
        toRemove.add(process);
        preparats.add(process);
        //Refresquem la cua de preparats.
        addToPreparats();
      }
    });
    toRemove.forEach((process) => entradaSortida.remove(process));
    selectRunningProcess();

    //Processem el proces que s'està executant
    if (running != null &&
        resultats[running.name - "A".codeUnitAt(0)][time] != "W") {
      if (algorithm == 'Round Robin') quantum--;
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
