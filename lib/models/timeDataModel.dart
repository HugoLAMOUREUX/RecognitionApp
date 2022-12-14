import 'package:cloud_firestore/cloud_firestore.dart';

class TimeDataModel {
  late int t; //microsecondsSinceEpoch
  late double ax;
  late double ay;
  late double az;
  late double gx;
  late double gy;
  late double gz;

  TimeDataModel.withAll({
    required this.t,
    required this.ax,
    required this.ay,
    required this.az,
    required this.gx,
    required this.gy,
    required this.gz,
  });

  TimeDataModel.fromJson(Map<String, dynamic> json) {
    TimeDataModel.withAll(
        t: json['t'],
        ax: json['ax'],
        ay: json['ay'],
        az: json['az'],
        gx: json['gx'],
        gy: json['gy'],
        gz: json['gz']);
  }

  TimeDataModel.withAcc({
    required this.t,
    required this.ax,
    required this.ay,
    required this.az,
    this.gx = 0,
    this.gy = 0,
    this.gz = 0,
  });

  TimeDataModel.withGyr({
    required this.t,
    required this.gx,
    required this.gy,
    required this.gz,
    this.ax = 0,
    this.ay = 0,
    this.az = 0,
  });

  set setAx(ax) {
    this.ax = ax;
  }

  set setAy(ay) {
    this.ay = ay;
  }

  set setAz(az) {
    this.az = az;
  }

  set setGx(gx) {
    this.gx = gx;
  }

  set setGy(gy) {
    this.gy = gy;
  }

  set setGz(gz) {
    this.gz = gz;
  }

  Map<String, dynamic> toMap() {
    return {"t": t, "ax": ax, "ay": ay, "az": az, "gx": gx, "gy": gy, "gz": gz};
  }

  Map<String, dynamic> toSensorsMap() {
    return {"ax": ax, "ay": ay, "az": az, "gx": gx, "gy": gy, "gz": gz};
  }

  //same as the one above
  Map<String, dynamic> toJson() {
    return {"t": t, "ax": ax, "ay": ay, "az": az, "gx": gx, "gy": gy, "gz": gz};
  }

  @override
  String toString() {
    return t.toString() +
        " : " +
        "ax:" +
        ax.toString() +
        "ay:" +
        ay.toString() +
        "az:" +
        az.toString() +
        "gx" +
        gx.toString() +
        "gy" +
        gy.toString() +
        "gz" +
        gz.toString() +
        "\n";
  }
}
