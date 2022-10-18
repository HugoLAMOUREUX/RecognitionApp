import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recognition/models/timeDataModel.dart';
import 'package:recognition/widgets/smallText.dart';
import 'package:recognition/widgets/timeSerieChartWidget.dart';

class SingleRecordingItem extends StatelessWidget {


  const SingleRecordingItem( {Key? key, required this.owner, required this.activity,required this.date, required this.duration, required this.timeSerie}) : super(key: key);

  final String owner;
  final String activity;
  final String date;
  final int duration;
  final List<TimeDataModel> timeSerie;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      margin: const EdgeInsets.only(left: 24,right: 24,top: 10,bottom: 10),
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
                  SmallText(text:"duree : ${duration}s"),
                  SmallText(text:"date : ${date}",maxLength: 23),
                  SmallText(text:"activity : ${activity}",maxLength: 19,),
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
