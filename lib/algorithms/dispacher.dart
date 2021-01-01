import 'process.dart';
import 'dart:collection';

class Dispacher {
  final int cpus;
  final List<int> arrivalTimeList;
  final List<String> jobBurstList;
  final String mode;
  final String algorithm;
  Dispacher(
      {this.cpus,
      this.arrivalTimeList,
      this.jobBurstList,
      this.mode,
      this.algorithm});

  List<Process> createProcesses(
      List<int> arrivalTimeList, List<String> jobBurstList) {
    List<Process> list = [];
    for (int i = 0; i < arrivalTimeList.length; i++) {
      list.add(Process(arrivalTimeList[i], jobBurstList[i], i));
    }
    return list;
  }

  List<int> run() {
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
  }

  //FIFO
  //First-In-First-Out i el procés només s'allibera quan s'acaba la seva execució o fa E/S
  List<int> fifo() {
    List<Process> processes =
        this.createProcesses(this.arrivalTimeList, this.jobBurstList);
    Queue preparats = Queue();
    Process running;
    int time = 0;
    List<int> results = [];
    while (processes.length != 0 && time < 100) {
      processes.forEach((process) {
        if (process.needToIO) {
          process.jobBurst[0]--;
          if (process.finishedJob()) process.doneJob();
        }
        if (process.arrivalTime == time) preparats.add(process);
      });

      if (running == null && preparats.isNotEmpty) {
        running = preparats.removeFirst();
      }
      if (running != null) {
        if (!running.finishedJob()) {
          running.jobBurst[0]--;
        } else {
          running.doneJob();
          if (!running.finished()) {
            preparats.add(running);
            running = null;
          }
        }
      }

      if (running != null && running.finished()) {
        print(
            String.fromCharCode(running.name) + ' has finished at time $time');
        results.add(running.name);
        results.add(time);
        processes.remove(running);
        running = null;
        if (preparats.isNotEmpty) {
          running = preparats.removeFirst();
          running.jobBurst[0]--;
        }
      }

      print('\nTIME: $time');
      processes.forEach((process) {
        if (running == process)
          print(String.fromCharCode(process.name) +
              ': running (remaining:' +
              process.jobBurst[0].toString() +
              ')');
        else if (preparats.contains(process))
          print(String.fromCharCode(process.name) + ': preparat');
        else if (processes.contains(process))
          print(String.fromCharCode(process.name) + ': encara no ha arribat');
      });

      time++;
    }
    return results;
  }

  //SJF
  //El processador s'assigna al procés amb la ràfegua de CPU més curta.
  //En cas d'empat, FIFO
  List<int> sjf() {
    List<Process> processes =
        this.createProcesses(this.arrivalTimeList, this.jobBurstList);
    final List<Process> processesOriginal = processes;
    List<Process> preparats = [];
    Process running;
    int time = 0;
    List<int> results = [];
    while (processes.length != 0 && time < 10) {
      processes.forEach((process) {
        if (process.needToIO) {
          process.jobBurst[0]--;
          if (process.finishedJob()) process.doneJob();
        }
        if (process.arrivalTime == time) {
          preparats.add(process);
          preparats.sort((a, b) => a.getNextJob().compareTo(b.getNextJob()));
        }
      });

      if (running == null && preparats.isNotEmpty) {
        running = preparats.removeAt(0);
      }
      if (running != null) {
        if (!running.finishedJob()) {
          running.jobBurst[0]--;
        } else {
          running.doneJob();
          if (!running.finished()) {
            preparats.add(running);
            running = null;
          }
        }
      }

      if (running != null && running.finished()) {
        print(
            String.fromCharCode(running.name) + ' has finished at time $time');
        results.add(running.name);
        results.add(time);
        processes.remove(running);
        running = null;
        if (preparats.isNotEmpty) {
          running = preparats.removeAt(0);
          running.jobBurst[0]--;
        }
      }

      print('\nTIME: $time');
      processes.forEach((process) {
        if (running == process)
          print(String.fromCharCode(process.name) +
              ': running (remaining:' +
              process.jobBurst[0].toString() +
              ')');
        else if (preparats.contains(process))
          print(String.fromCharCode(process.name) + ': preparat');
        else if (processes.contains(process))
          print(String.fromCharCode(process.name) + ': encara no ha arribat');
      });
      time++;
    }

    return results;
  }

  List<int> roundRobin() {
    List<Process> processes =
        this.createProcesses(this.arrivalTimeList, this.jobBurstList);
    Queue preparats = Queue();
    Process running;
    int time = 0;
    List<int> results = [];
    return results;
  }

  List<int> priorities() {
    List<Process> processes =
        this.createProcesses(this.arrivalTimeList, this.jobBurstList);
    Queue preparats = Queue();
    Process running;
    int time = 0;
    List<int> results = [];
    return results;
  }
}
