import 'dart:ffi';


import 'package:recognition/models/timeDataModel.dart';



class TimeSerieModel {
  late List<TimeDataModel> timeSerie;
  late String owner;
  late DateTime date;
  late int duration;

  TimeSerieModel.copy(TimeSerieModel ts){
    timeSerie=new List<TimeDataModel>.from(ts.timeSerie);
    owner=ts.owner;
    date=ts.date;

    //bon faudra aussi modifier duration mais flemme hein
    duration=ts.duration;
  }

  TimeSerieModel(this.owner) {
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

  //ici dynamic est utilisé pour suivre la doc, a voir si il faut le modifier
  Map<String, dynamic> toMap(String type) {
    Map<String, dynamic> res = {};
    List<Map<String, dynamic>> timedata =
        []; // pour envoyer une liste de timedatamodel
    ///Map<String,dynamic> timedata={}; //pour envoyer un json des timestamps

    res["Owner"]=owner;
    res["Activity"] = type;
    res["Date"]=date;
    res["Duration"]=duration;

    for(TimeDataModel d in timeSerie){
      int time=d.t;

      ///timedata["$time"]=d.toSensorsMap(); // pour ajouter une map des sensor values dans le clé timestamp
      timedata.add(d.toMap()); // pour ajouter une map de timedatamodel
    }

    res["TimeSerie"] = timedata;
    return res;
  }

  void setTime(DateTime startTime) {
      date=startTime;
  }

  int setDuration(DateTime endTime){
    Duration delta=endTime.difference(date);
    duration=delta.inSeconds;
    return duration;
  }


  TimeSerieModel crop(int start,int end){
    TimeSerieModel newTs=TimeSerieModel.copy(this);
    print("trying to remove $start and $end points");

    newTs.timeSerie.removeRange(0, start);
    newTs.timeSerie.removeRange(newTs.timeSerie.length-end,newTs.timeSerie.length);

    //moche un peu
    Duration delta=new Duration(microseconds:(newTs.timeSerie[newTs.timeSerie.length-1].t)-(newTs.timeSerie[0].t));
    newTs.duration=delta.inSeconds;

    return newTs;
  }


}
