import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import '../models/timeDataModel.dart';

///widget pour afficher des series statiques
class TimeSeriesChartWidget extends StatelessWidget {
  final List<TimeDataModel> seriesdata;
  /*=[
    TimeDataModel.withAcc(t:DateTime(2017, 9, 1),ax:2,ay:2,az:2),
    TimeDataModel.withAcc(t:DateTime(2017, 9, 2),ax:2,ay:3,az:2),
    TimeDataModel.withAcc(t:DateTime(2017, 9, 3),ax:2,ay:4,az:2),
    TimeDataModel.withAcc(t:DateTime(2017, 9, 4),ax:2,ay:5,az:2),
    TimeDataModel.withAcc(t:DateTime(2017, 9, 5),ax:2,ay:3,az:2),
    TimeDataModel.withAcc(t:DateTime(2017, 9, 6),ax:2,ay:2,az:2),
    TimeDataModel.withAcc(t:DateTime(2017, 9, 7),ax:2,ay:3,az:2),
    TimeDataModel.withAcc(t:DateTime(2017, 9, 8),ax:2,ay:4,az:2),
    TimeDataModel.withAcc(t:DateTime(2017, 9, 9),ax:2,ay:6,az:2),
    TimeDataModel.withAcc(t:DateTime(2017, 9, 10),ax:2,ay:7,az:2),
    TimeDataModel.withAcc(t:DateTime(2017, 9, 11),ax:2,ay:8,az:2)
  ] ;*/

  TimeSeriesChartWidget(this.seriesdata, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
        return  SfSparkLineChart.custom(
        axisLineWidth: 0,
        // Binding the x values
        xValueMapper: (int index) => seriesdata[index].t,
        // Binding the y values
        yValueMapper: (int index) => seriesdata[index].ay,
        // Assigning the number of data.
        dataCount: seriesdata.length,
        );

  }



}

