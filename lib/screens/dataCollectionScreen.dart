import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:recognition/models/timeDataModel.dart';
import 'package:recognition/models/timeSerieModel.dart';
import 'package:sensors_plus/sensors_plus.dart';

class DataCollectionScreen extends StatefulWidget {
  DataCollectionScreen({Key? key}) : super(key: key);

  @override
  State<DataCollectionScreen> createState() => _DataCollectionScreenState();
}

class _DataCollectionScreenState extends State<DataCollectionScreen> {
  double xAcc = 0.0;
  double yAcc = 0.0;
  double zAcc = 0.0;
  double xGyr = 0.0;
  double yGyr = 0.0;
  double zGyr = 0.0;
  bool recording = false;
  TimeSerieModel timeSerie = TimeSerieModel();

  DateTime lastModifiedAcc = DateTime.now();
  DateTime lastModifiedGyr = DateTime.now();

  double step = 0.005;

  @override
  void initState() {
    accelerometerEvents.listen((AccelerometerEvent event) {
      if (DateTime.now().difference(lastModifiedAcc).inSeconds > step &&
          recording) {
        DateTime t = DateTime.now();
        xAcc = event.x;
        yAcc = event.y;
        zAcc = event.z;
        timeSerie.addTimeDataModel(
            TimeDataModel.withAcc(t: t, ax: xAcc, ay: yAcc, az: zAcc));
        lastModifiedAcc = t;
        print(inspect(timeSerie));
        //rebuild the widget
        setState(() {});
      }
    });

    gyroscopeEvents.listen((GyroscopeEvent event) {
      if (DateTime.now().difference(lastModifiedGyr).inSeconds > step &&
          recording) {
        DateTime t = DateTime.now();

        xGyr = event.x;
        yGyr = event.y;
        zGyr = event.z;
        timeSerie.addTimeDataModel(
            TimeDataModel.withGyr(t: t, gx: xGyr, gy: yGyr, gz: zGyr));

        lastModifiedGyr = t;

        setState(() {});
      }
      //print(event);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(children: [
            Text("xAcc : " + xAcc.toString()),
            Text("yAcc : " + yAcc.toString()),
            Text("zAcc : " + zAcc.toString()),
            Text("xGyr : " + xGyr.toString()),
            Text("yGyr : " + yGyr.toString()),
            Text("zGyr : " + zGyr.toString()),
            ElevatedButton(
              onPressed: () {
                recording = true;
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                primary: Theme.of(context).primaryColor,
              ),
              child: Text(
                'Record'.toUpperCase(),
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                recording = false;
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                primary: Theme.of(context).primaryColor,
              ),
              child: Text(
                'STOP'.toUpperCase(),
                style: TextStyle(color: Colors.white),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
