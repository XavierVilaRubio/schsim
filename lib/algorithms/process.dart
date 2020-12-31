class Process {
  int arrivalTime;
  List<int> jobBurst;
  bool needToIO = false;
  int name = "A".codeUnitAt(0);
  Process(int arrivalTime, String jobBurst, int name) {
    this.arrivalTime = arrivalTime;
    this.jobBurst = jobBurst.split(",").map(int.parse).toList();
    this.name += name;
  }

  bool finished() {
    return this.jobBurst.length == 0;
  }

  bool finishedJob() {
    return this.jobBurst[0] == 0;
  }

  int getNextJob() {
    return this.jobBurst[0];
  }

  void doneJob() {
    this.jobBurst.removeAt(0);
    this.needToIO = !this.needToIO;
  }
}
