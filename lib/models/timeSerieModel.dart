import 'dart:ffi';

import 'package:recognition/models/timeDataModel.dart';

class TimeSerieModel {
  late List<TimeDataModel> timeSerie;

  TimeSerieModel() {
    timeSerie = [];
  }

  void addTimeDataModel(TimeDataModel data) {
    timeSerie.add(data);
  }

  List<TimeDataModel> getTimeSerieModel() {
    return timeSerie;
  }

  @override
  String toString() {
    return timeSerie.toString();
  }
}
