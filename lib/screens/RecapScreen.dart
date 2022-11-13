import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recognition/screens/HomeScreen.dart';
import 'package:recognition/widgets/detailedRecording.dart';

import '../models/timeSerieModel.dart';
import '../widgets/singleRecordingItem.dart';

class RecapScreen extends StatefulWidget {
  final TimeSerieModel timeSerie;
  const RecapScreen({super.key, required TimeSerieModel this.timeSerie});

  @override
  State<RecapScreen> createState() => _RecapScreenState();
}

class _RecapScreenState extends State<RecapScreen> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, //pour cacher la flèche arrière
          title: Text("Recap"),
        ),
        body: Center(
          child: Column(
            children: [

              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "This is the Time Series you have just recorded",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 25,
                  ),
                ),
              ),
              SizedBox(
                height: 30,width: double.infinity,
              ),
              DetailedRecording(
                  owner: widget.timeSerie.getOwner(),
                  activity: widget.timeSerie.getActivity(),
                  date: (Timestamp.fromDate(widget.timeSerie.getDate()))
                      .toDate()
                      .toString(),
                  duration: widget.timeSerie.getDuration(),
                  timeSerie: widget.timeSerie.getTimeSerieModel()
              ),
              IconButton(
                icon: Icon(Icons.edit),
                color: Colors.blue,
                onPressed: () {},
              ),
              ElevatedButton(
                onPressed: () {
                  // Ajoute une nouvelle  timeseries avec un id généré sur firestore
                  _firebaseFirestore
                      .collection("timeSeries")
                      .add(widget.timeSerie.toMap())
                      .then((DocumentReference doc) =>
                          print('TimeSerie added with ID: ${doc.id}'));
                  // Revient à la page HomeScreen
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
                      (route) => false);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 10.0),
                  primary: Theme.of(context).primaryColor,
                ),
                child: Text(
                  'Send'.toUpperCase(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
