class Process {
  int arrivalTime = 0;
  List<int> jobBurst = [];
  List<int> originalJobBurst = [];
  //Assumim que el primer valor de la ràfaga sempre serà CPU i no E/S.
  bool doingIO = false;
  int name = "A".codeUnitAt(0);
  int priority = 0;
  Process.origin();

  Process(int arrivalTime, String jobBurst, int name, int priority) {
    this.arrivalTime = arrivalTime;
    this.jobBurst = jobBurst.split(",").map(int.parse).toList();
    this.name += name;
    this.priority = priority;
    this.originalJobBurst = jobBurst.split(",").map(int.parse).toList();
  }

  Process.int(int arrivalTime, List<int> jobBurst, int name, int priority) {
    this.arrivalTime = arrivalTime;
    this.jobBurst = jobBurst;
    this.name = name;
    this.priority = priority;
    this.originalJobBurst = jobBurst;
  }

  bool finishedJob() {
    return jobBurst[0] == 0;
  }

  int getNextJob() {
    return this.jobBurst[0];
  }

  int doneJob() {
    if (jobBurst.length > 1) {
      originalJobBurst.removeAt(0);
      jobBurst.removeAt(0);
      doingIO = !doingIO;
    }
    if (jobBurst.length == 1 && jobBurst[0] == 0) {
      return 1; //ha acabat la seva vida
    }
    return 0; //ha acabat un job i needs to IO
  }

  int work() {
    if (!finishedJob()) jobBurst[0]--;
    if (finishedJob()) return doneJob();
    return -1; //segueix tot normal ok
  }

  String getName() {
    return String.fromCharCode(this.name);
  }

  Process.clone(Process process)
      : this.int(process.arrivalTime, process.jobBurst, process.name,
            process.priority);
}
