import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recognition/widgets/smallText.dart';
import 'package:recognition/widgets/timeSerieChartWidget.dart';

import '../models/timeDataModel.dart';

class DetailedRecording extends StatelessWidget {
  final String owner;
  final String activity;
  final String date;
  final int duration;
  final List<TimeDataModel> timeSerie;

  const DetailedRecording({Key? key,
    required this.owner,
    required this.activity,
    required this.date,
    required this.duration,
    required this.timeSerie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 300,
        margin: const EdgeInsets.only(left: 24, right: 24, top: 10, bottom: 10),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(
                  0.0,
                  0.0,
                ),
                blurRadius: 5.0,
                spreadRadius: 1.0,
              )
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex:6,
              child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.black12, width: 1.0)
                      )
                  ),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                  child: Center(
                    child: TimeSeriesChartWidget(
                        seriesdata: timeSerie, color: Colors.blueAccent),
                  ),
                ),
            ),

           Expanded(
             flex:4,
             child: Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Duration : ${duration}s",style: TextStyle(fontSize: 18)),
                      Text("Date : ${date.substring(0,16)}",style: TextStyle(fontSize: 18)),
                      Text("Activity : ${activity}",style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
           ),
          ],
        )
    );
  }
}
