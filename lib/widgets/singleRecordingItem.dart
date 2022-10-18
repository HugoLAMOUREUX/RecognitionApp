import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recognition/models/timeDataModel.dart';
import 'package:recognition/widgets/timeSerieChartWidget.dart';

class SingleRecordingItem extends StatelessWidget {


  const SingleRecordingItem( {Key? key, required this.owner, required this.activity, required this.timeSerie}) : super(key: key);

  final List<TimeDataModel> timeSerie;
  final String owner;
  final String activity;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      margin: const EdgeInsets.only(left: 24,right: 24,top: 10,bottom: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: const Offset(
                0.0,
                0.0,
              ),
              blurRadius: 5.0,
              spreadRadius: 1.0,)
          ]

      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color:Colors.black12,width: 1.0)
                )
              ),
              //color: Colors.red,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("duree : 22s"),
                  Text("data : date"),
                  Text("activity : $activity"),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              //color: Colors.white,
              margin: EdgeInsets.all(10),
              child: Center(
                child: TimeSeriesChartWidget(seriesdata:timeSerie,color:Colors.blueAccent),
              ),

            ),
          )
        ],
      ));
  }
}
