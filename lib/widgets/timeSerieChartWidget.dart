import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import '../models/timeDataModel.dart';

///widget pour afficher des series statiques
class TimeSeriesChartWidget extends StatelessWidget {


  TimeSeriesChartWidget( {Key? key,required this.seriesdata,this.color=Colors.blueAccent}) : super(key: key);


  final List<TimeDataModel> seriesdata;
  final Color color;

  @override
  Widget build(BuildContext context) {
        return  SfSparkLineChart.custom(
          color: color,
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

