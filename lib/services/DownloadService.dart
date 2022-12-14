import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';

class DownloadService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  String jsonString = "";

  Map dataFromFirebase(String user) {
    var data;
    if (user == null || user == "") {
      data = _firebaseFirestore.collection("timeSeries").snapshots();
      print(data);
      print(data.runtimeType);
    } else {}
    //to delete
    return new Map();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/dataset.json');
  }

  Future<File> writeDataSet(Map json) async {
    final file = await _localFile;

    //Convert json ->jsonString
    jsonString = jsonEncode(json);

    // Write the file
    return file.writeAsString('$jsonString');
  }
}
