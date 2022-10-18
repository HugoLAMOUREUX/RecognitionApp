import 'dart:ffi';

import 'package:recognition/models/timeDataModel.dart';

class TimeSerieModel {
  late List<TimeDataModel> timeSerie;
  late String owner;
  //intégrer owner et activity a model timeserie ? créer un autre model ?

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

    for(TimeDataModel d in timeSerie){
      int time=d.t;

      ///timedata["$time"]=d.toSensorsMap(); // pour ajouter une map des sensor values dans le clé timestamp

      timedata.add(d.toMap()); // pour ajouter une map de timedatamodel
    }

    res["TimeSerie"] = timedata;
    return res;
  }
}
