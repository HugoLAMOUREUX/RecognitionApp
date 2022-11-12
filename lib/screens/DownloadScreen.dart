import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({super.key});

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  int nbDocs = 0;
  bool onlyUser = false;
  List<Map> staticData = LabelDownload.data;

  Widget _buildSelectIcon(bool isSelected) {
    return Icon(
      isSelected ? Icons.check_box : Icons.check_box_outline_blank,
      color: Theme.of(context).primaryColor,
    );
  }

  @override
  void initState() {
    countTS();
  }

  ///Mets à jour l'index selectionné quand on clique sur un label
  void onTap() {
    setState(() {
      onlyUser = !onlyUser;
      //print(widget.timeSerie);
    });
    countTS();
  }

  void countTS() {
    if (onlyUser) {
      _firebaseFirestore
          .collection("timeSeries")
          .where("Owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((QuerySnapshot querySnapshot) {
        setState(() {
          nbDocs = querySnapshot.size;
        });
      });
    } else {
      _firebaseFirestore
          .collection("timeSeries")
          .get()
          .then((QuerySnapshot querySnapshot) {
        setState(() {
          nbDocs = querySnapshot.size;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Download data"),
        ),
        body: Center(
          child: Column(children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "Recap",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 25,
                ),
              ),
            ),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ListView.builder(
                itemBuilder: (builder, index) {
                  Map data = staticData[index];
                  return ListTile(
                    onTap: () => onTap(),
                    title: Text("${data['name']}"),
                    leading: _buildSelectIcon(onlyUser), // updated
                  );
                },
                itemCount: staticData.length,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              'The dataset contains $nbDocs time series ',
              style: TextStyle(
                color: Colors.black.withOpacity(0.4),
                fontSize: 12.0,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: (() {}),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
              ),
              child: const Text(
                'Receive the dataset via mail',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: (() {}),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
              ),
              child: const Text(
                'Download the dataset',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class LabelDownload {
  static List<Map> data = [
    {
      "id": 1,
      "name": "Download only your activities",
    },
  ];
}
