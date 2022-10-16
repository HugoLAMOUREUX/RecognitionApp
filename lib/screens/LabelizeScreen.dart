import 'package:flutter/material.dart';
import 'package:recognition/models/timeSerieModel.dart';
import 'package:recognition/screens/HomeScreen.dart';
import 'package:recognition/screens/Labels.dart';

class LabelizeScreen extends StatefulWidget {
  final TimeSerieModel timeSerie;
  const LabelizeScreen({super.key, required TimeSerieModel this.timeSerie});

  @override
  State<LabelizeScreen> createState() => _LabelizeScreenState();
}

class _LabelizeScreenState extends State<LabelizeScreen> {
  //pour recuprer la donnée passé : widget.timeSerie
  List<Map> staticData = Labels.data;
  int selectedIndex = 0;

  Widget _buildSelectIcon(bool isSelected, Map data) {
    return Icon(
      isSelected ? Icons.check_box : Icons.check_box_outline_blank,
      color: Theme.of(context).primaryColor,
    );
  }

  void onTap(bool isSelected, int index) {
    setState(() {
      selectedIndex = index;
      print(widget.timeSerie);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
            child: Column(
          children: [
            SizedBox(
              height: 400,
              width: double.infinity,
              child: ListView.builder(
                itemBuilder: (builder, index) {
                  Map data = staticData[index];
                  bool isSelected = index == selectedIndex;
                  return ListTile(
                    onTap: () => onTap(isSelected, index),
                    title: Text("${data['name']}"),
                    leading: _buildSelectIcon(isSelected, data), // updated
                  );
                },
                itemCount: staticData.length,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                    (route) => false);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                primary: Theme.of(context).primaryColor,
              ),
              child: Text(
                'SEND'.toUpperCase(),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
