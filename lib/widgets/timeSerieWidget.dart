//import 'package:flutter/cupertino.dart';
//import 'package:charts_flutter/flutter.dart' as charts;
//import 'package:flutter/material.dart';
//import 'package:recognition/screens/dataCollectionScreen.dart';

//import '../models/timeDataModel.dart';
//import '../models/timeSerieModel.dart';
/*
/*
class TimeSerieChart extends StatefulWidget {


  const TimeSerieChart({Key? key}) : super(key: key);

  @override
  State<TimeSerieChart> createState() => _TimeSerieChartState(data: []);
}

class _TimeSerieChartState extends State<TimeSerieChart> {
  late List<TimeDataModel> data;

  _TimeSerieChartState({required this.data});

  @override
  void initState() {

  }

  @override
  Widget build(BuildContext context) {
  }
}

 */
class TimeSerieChart extends StatelessWidget {
  final List<TimeDataModel> seriesdata;
  //List<charts.Series<dynamic, DateTime>> seriesList;
  final bool animate;


  TimeSerieChart(this.seriesdata, {required this.animate});

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  factory TimeSerieChart.withSampleData() {
    return new TimeSerieChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }


  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      _createData(),
      animate: animate,
      // Optionally pass in a [DateTimeFactory] used by the chart. The factory
      // should create the same type of [DateTime] as the data provided. If none
      // specified, the default creates local date time.
      dateTimeFactory: const charts.LocalDateTimeFactory(),
    );
  }

  /// Create one series with sample hard coded data.
  static List<TimeDataModel> _createSampleData() {
    final data =
      [
        TimeDataModel.withAcc(t:DateTime(2017, 9, 2),ax:2,ay:2,az:2),
        TimeDataModel.withAcc(t:DateTime(2017, 9, 12),ax:2,ay:5,az:2),
        TimeDataModel.withAcc(t:DateTime(2017, 9, 19),ax:2,ay:2,az:2),
        TimeDataModel.withAcc(t:DateTime(2017, 9, 25),ax:2,ay:1,az:2),
      ]
    ;
    return data ;
  }

  List<charts.Series<TimeDataModel, DateTime>> _createData() {

    return [
      charts.Series<TimeDataModel, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeDataModel sales, _) => sales.t,
        measureFn: (TimeDataModel sales, _) => sales.ay,
        data: seriesdata,
      )
    ];
  }
}

/// Sample time series data type.
class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}
*/