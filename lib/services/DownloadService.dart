import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';

class DownloadService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  String jsonString = "";

  void writeDataSet(onlyUser) async {
    //get the download directory on android
    //ios ???
    Directory generalDownloadDir = Directory('/storage/emulated/0/Download');
    File file = await File('${generalDownloadDir.path}/dataset.json').create();
    var data = [];

    //get the data
    _firebaseFirestore
        .collection("timeSeries")
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        data.add(doc.data());
      });

      if (onlyUser) {
        data = data
            .where((e) => e["Owner"] == FirebaseAuth.instance.currentUser!.uid)
            .toList();
      }

      //changing the timestamp to string otherwhise we can't use jsonEncode
      //jsonEncode usable only on String, int ...
      data.forEach((element) {
        element["Date"] = element["Date"].toString();
        element["TimeSerie"].forEach((e) {
          e["t"] = e["t"].toString();
        });
      });

      //json->jsonString
      jsonString = jsonEncode(data);
      // Write the file
      file.writeAsString('$jsonString');
      //Confirm to the user that the file is downloaded
      Fluttertoast.showToast(
        msg: 'JSON file saved in Downloads',
        fontSize: 18,
      );
    });
  }
}
