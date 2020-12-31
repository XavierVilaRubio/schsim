import 'process.dart';
import 'dart:collection';
//FIFO
//First-In-First-Out i el procés només s'allibera quan s'acaba la seva execució o fa E/S

class FifoAlgorithm {
  final int cpus;
  final List<int> arrivalTimeList;
  final List<String> jobBurstList;
  final String mode;
  final String algorithm;
  FifoAlgorithm(
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

  List<int> process(List<Process> processes) {
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
    print(results);
    return results;
  }
}
