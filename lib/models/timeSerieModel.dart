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

  Map<String, dynamic> toListofMap(){
    Map<String,dynamic> res={};
    //int i=0;
    for(TimeDataModel d in timeSerie){
      DateTime time=d.t;
      res["$time"]=d.toSensorsMap();
      //i=i+1;
    }
    return res;
    //temporairement juste le first
  }
}
