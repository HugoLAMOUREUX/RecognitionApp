import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:recognition/models/timeDataModel.dart';
import 'package:recognition/models/timeSerieModel.dart';
import 'package:recognition/screens/Guest/Guest.dart';
import 'package:recognition/screens/LabelizeScreen.dart';
import 'package:recognition/services/UserService.dart';
import 'package:recognition/widgets/timeSerieWidget.dart';
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

  late List<TimeDataModel> timeChartData;

  bool recording = false;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  late TimeSerieModel timeSerie;

  UserService _userService = UserService();

  //pour cloud firestore
  late var db;

  //nombre de données entrées par enregistrement
  int nbEntries = 0;

  //user data
  late User user;
  late String uid;

  //test test
  List<TimeDataModel> dataseries = [
    TimeDataModel.withAcc(t: DateTime(2019, 2, 3), ax: 2, ay: 2, az: 2),
    TimeDataModel.withAcc(t: DateTime(2019, 2, 9), ax: 2, ay: 3, az: 2),
    TimeDataModel.withAcc(t: DateTime(2019, 2, 17), ax: 2, ay: 1, az: 2),
    TimeDataModel.withAcc(t: DateTime(2019, 2, 24), ax: 2, ay: 6, az: 2),
  ];

  void getFirstName() async {
    //pour recup l'user authentifié
    print("debut datascreen collection auth");
    final user = auth.currentUser;
    //pour recup l'id de l'user authentifié
    uid = user!.uid;
    print("uid dans datascreen collection");
    print(uid);
    print(user.email);

    //recup le firstName de l'user authentifié
    DocumentReference documentReference =
        _firebaseFirestore.collection('users').doc(user.email);
    DocumentSnapshot documentSnapshot = await documentReference.get();
    if (documentSnapshot.exists) {
      String firstName = documentSnapshot.get('firstName');
      print("-----------------------");
      print(firstName);
      print("-----------------------");
    }
    //firstName est recup mtn
  }

  @override
  void initState() {
    getFirstName();

    timeSerie = TimeSerieModel(uid);

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
    });

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
            ElevatedButton(
              onPressed: recording
                  ? null
                  : () {
                      recording = true;
                      print(recording);
                      setState(() {});
                      timer =
                          Timer.periodic(Duration(milliseconds: 50), (Timer t) {
                        timeSerie.addTimeDataModel(TimeDataModel.withAll(
                            t: DateTime.now(),
                            ax: xAcc,
                            ay: yAcc,
                            az: zAcc,
                            gx: xGyr,
                            gy: yGyr,
                            gz: zGyr));
                        nbEntries++;
                      });
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
              onPressed: !recording
                  ? null
                  : () {
                      recording = false;
                      print(recording);
                      timeChartData = timeSerie.getTimeSerieModel();

                      setState(() {});
                      Fluttertoast.showToast(
                        msg: 'Recording ended with $nbEntries entries',
                        fontSize: 18,
                      );
                      timer.cancel();
                      nbEntries = 0;

                      //pour utiliser firestore
                      db
                          .collection("timeSeries")
                          .add(timeSerie.toListofMap())
                          .then((DocumentReference doc) =>
                              print('TimeSerie added with ID: ${doc.id}'));
                      // Ajoute une nouvelle  timeseries avec un id généré
                      print("sent on firestore");
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  LabelizeScreen(timeSerie: timeSerie)),
                          (route) => false);
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
            ),
            /*
            // JE MET EN COMMENTAIRE PARCE QUE CA CREE DES WARNING
            // JAI COMMENTE LA DEPENDANCE CORRESPONDANTE DANS PUBSPEC
            // ET COMMENTE LA CLASSE TIMESERIEWIDGET
            Container(
               child: TimeSerieChart.withSampleData(),
               height: 300,
             ),
            //BOUTON TEST AJOUT DE POINT A LA SERIE
            ElevatedButton(
              onPressed: true ? _addPoint():null,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                primary: Theme.of(context).primaryColor,
              ),
              child: Text(
                'Add Point'.toUpperCase(),
                style: TextStyle(color: Colors.white),
              ),
            )*/
          ]),
        ),
      ),
    );
  }

  /// Function to add new point to time series
  _addPoint() {
    this.dataseries.add(
        TimeDataModel.withAcc(t: DateTime(2019, 3, 10), ax: 2, ay: 2, az: 2));
    setState(() {});
    Fluttertoast.showToast(
      msg: 'point ajouté peut etre',
      fontSize: 18,
    );
    return null;
  }

  /// Sample time series data
  List<TimeDataModel> _createData() {
    return this.dataseries;
  }
}
