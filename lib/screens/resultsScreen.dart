import 'package:flutter/material.dart';

class ResultsScreen extends StatelessWidget {
/*   final String cpus;
  final List<String> arrivalTimeList;
  final List<String> jobBurstList;
  final String mode;
  final String algorithm; */
  final String cpus;
  final List<String> arrivalTimeList;
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('SCHSIM Results'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('CPUs: $cpus'),
          Text('Jobs: ' + arrivalTimeList.length.toString()),
          Container(
            width: 1000,
            margin: EdgeInsets.only(
                left: (MediaQuery.of(context).size.width / 2) - 25),
            height: (15 * arrivalTimeList.length).toDouble(),
            child: ListView.builder(
              itemCount: arrivalTimeList.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Text(arrivalTimeList[index] + ': '),
                    Text(jobBurstList[index] + '.'),
                  ],
                );
              },
            ),
          ),
          Text('Arrival Time List: $arrivalTimeList'),
          Text('Job Burst List: $jobBurstList'),
          Text('Mode: $mode'),
          Text('Algorithm: $algorithm'),
        ],
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
