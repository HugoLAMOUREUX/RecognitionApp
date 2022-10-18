import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recognition/widgets/singleRecordingItem.dart';

import '../models/timeDataModel.dart';

class UserHistoryWidget extends StatefulWidget {
  UserHistoryWidget({Key? key}) : super(key: key);

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  State<UserHistoryWidget> createState() => _UserHistoryWidgetState();
}

class _UserHistoryWidgetState extends State<UserHistoryWidget> {


  @override
  Widget build(BuildContext context) {
    return Container(
        height: 600,
        // decoration: BoxDecoration(color: Colors.red),
        child: StreamBuilder(
          stream: widget._firebaseFirestore.collection("timeSeries").where("Owner",isEqualTo: "rGKoKryATbft1dbNr48VP89NGyt1").snapshots(),
          builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
            if(!snapshot.hasData){
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView(
              children: snapshot.data!.docs.map((document){
                List<TimeDataModel> timeSerieRecording=document["TimeSerie"].map<TimeDataModel>((data) {
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
                ).toList();
                return Center(
                  child: SingleRecordingItem(owner:document["Owner"],activity:document["Activity"],timeSerie:timeSerieRecording),
                );
              }).toList(),
            );
          },
        )
    );
  }
}


/*
ListView.builder(
            itemCount: 5,
            itemBuilder: (BuildContext context, int position) {
              return SingleRecordingItem();

            })
 */