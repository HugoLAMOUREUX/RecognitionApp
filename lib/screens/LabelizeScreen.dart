import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recognition/models/timeSerieModel.dart';
import 'package:recognition/screens/HomeScreen.dart';
import 'package:recognition/screens/Labels.dart';

import '../models/timeDataModel.dart';
import '../widgets/edited_time_series_widget.dart';

class LabelizeScreen extends StatefulWidget {
  final TimeSerieModel timeSerie;
  const LabelizeScreen({super.key, required this.timeSerie});

  @override
  State<LabelizeScreen> createState() => _LabelizeScreenState();
}

class _LabelizeScreenState extends State<LabelizeScreen> {
  //pour recuprer la donnée passé : widget.timeSerie
  List<Map> staticData = Labels.data;
  int selectedIndex = 0;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Widget _buildSelectIcon(bool isSelected, Map data) {
    return Icon(
      isSelected ? Icons.check_box : Icons.check_box_outline_blank,
      color: Theme.of(context).primaryColor,
    );
  }

  ///Mets à jour l'index selectionné quand on clique sur un label
  void onTap(bool isSelected, int index) {
    setState(() {
      selectedIndex = index;
      //print(widget.timeSerie);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Time serie details"),
        ),
        body: SingleChildScrollView(
          child: Center(
              child: Column(
            children: [

              SizedBox(
                height: 400,
                width: double.infinity,
                child: ListView.builder(
                  itemBuilder: (builder, index) {
                    Map data = staticData[index];
                    bool isSelected = index == selectedIndex;
                    return ListTile(
                      onTap: () => onTap(isSelected, index),
                      title: Text("${data['name']}"),
                      leading: _buildSelectIcon(isSelected, data), // updated
                    );
                  },
                  itemCount: staticData.length,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Ajoute une nouvelle  timeseries avec un id généré sur firestore
                  _firebaseFirestore
                      .collection("timeSeries")
                      .add(widget.timeSerie
                          .toMap(staticData[selectedIndex]["name"]))
                      .then((DocumentReference doc) =>
                          print('TimeSerie added with ID: ${doc.id}'));
                  // Revient à la page HomeScreen
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                      (route) => false);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  primary: Theme.of(context).primaryColor,
                ),
                child: Text(
                  'SEND'.toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }

  /*
  Future<Map<String, dynamic>> getDataFromFireStore() async {

    return await _firebaseFirestore
        .collection("timeSeries")
        .doc("5oi0j4Eu9yJn84YOR6Cv")
        .get()
        .then(
          (DocumentSnapshot doc) {
        return doc.data() as Map<String, dynamic>;
        //final data = doc.data() as Map<String, dynamic>;
        //data["Activity"];
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }*/


/*
  Widget timeSerieBuilder(){
    return Container(
      height: 300,
      child: FutureBuilder<Map<String, dynamic>>(
          future: getDataFromFireStore(),
          builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.hasData) {
              return Center( // here only return is missing
                  child: EditedTimeSeriesWidget(inputChartData:snapshot.data!["TimeSerie"].map<TimeDataModel>((data) {
                    return TimeDataModel.withAll(
                        t: data['t'],
                        ax: data['ax'],
                        ay: data['ay'],
                        az: data['az'],
                        gx: data['gx'],
                        gy: data['gy'],
                        gz: data['gz']
                    );
                  }
                  ).toList(), editorController: _secondController,
                  )
              );
            }
            if (snapshot.hasError) {
              return Text('error $snapshot.data["Activity"]');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Text("waiting"),
              );
            }
            return const Text("not catched");
          }
      ),
    );
  }*/
}
