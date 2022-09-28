import 'dart:async';
import 'dart:developer';


import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:recognition/models/timeDataModel.dart';
import 'package:recognition/models/timeSerieModel.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  var timer;
  TimeSerieModel timeSerie = TimeSerieModel();
  bool recording=false;

  //pour realtime database
  late DatabaseReference ref;

  //pour cloud firestore
  late var db;

  //nombre de données entrées par enregistrement
  int nbEntries=0;



  @override
  void initState() {
    FirebaseDatabase database = FirebaseDatabase.instance;
    accelerometerEvents.listen((AccelerometerEvent event) {
      xAcc = event.x;
      yAcc = event.y;
      zAcc = event.z;
      //rebuild the widget
      setState(() {});
    });

    gyroscopeEvents.listen((GyroscopeEvent event) {
      xGyr = event.x;
      yGyr = event.y;
      zGyr = event.z;
      setState(() {});
      //print(event);
    });

    // pour utiliser realtime database,
    ref = FirebaseDatabase.instance.ref("users/123");

    // pour utiliser cloud firestore
    db = FirebaseFirestore.instance;

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
              onPressed: recording ? null : () {
                recording=true;
                print(recording);
                  setState((){});


                   timer = Timer.periodic(
                    Duration(milliseconds: 50),
                    (Timer t) {
                      timeSerie.addTimeDataModel(
                        TimeDataModel.withAll(
                            t: DateTime.now(),
                            ax: xAcc,
                            ay: yAcc,
                            az: zAcc,
                            gx: xGyr,
                            gy: yGyr,
                            gz: zGyr));
                      nbEntries++;}
                   );
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
              onPressed: !recording ? null: () {
                recording=false;
                print(recording);
                setState((){});
                Fluttertoast.showToast(
                msg:'Recording ended with $nbEntries entries',
                    fontSize:18,
                );
                timer.cancel();
                nbEntries=0;


                /*
                //pour utiliser realtime database
                ref.set({
                  "name": "John",
                  "age": 18,
                  "address": {
                    "line1": "100 Mountain View"
                  }
                });*/


                //pour utiliser firestore
                // Add a new document with a generated ID
                db.collection("timeSeries").add(timeSerie.toListofMap()).then((DocumentReference doc) =>
                    print('TimeSerie added with ID: ${doc.id}'));

                print("sent on firestore");


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
