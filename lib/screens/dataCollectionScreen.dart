import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:recognition/models/timeDataModel.dart';
import 'package:recognition/models/timeSerieModel.dart';
import 'package:recognition/screens/LabelizeScreen.dart';
import 'package:recognition/services/UserService.dart';
import 'package:recognition/widgets/dynamicTimeSeriesWidget.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class DataCollectionScreen extends StatefulWidget {
  DataCollectionScreen({Key? key}) : super(key: key);

  @override
  State<DataCollectionScreen> createState() => _DataCollectionScreenState();
}

///Screen qui permets de récupérer les données et de les afficher en temps réel
///
///un bouton Stop permets de passer à l'étape suivante qui est de labéliser la
///série enregistrée sur cet éran
class _DataCollectionScreenState extends State<DataCollectionScreen> {
  //Données de l'accéléromètre et du gyromètre
  double xAcc = 0.0;
  double yAcc = 0.0;
  double zAcc = 0.0;
  double xGyr = 0.0;
  double yGyr = 0.0;
  double zGyr = 0.0;

  //timer initialisé au lancement de l'activité
  var timer;

  //Série temporelle enregistrée
  late TimeSerieModel timeSerie;

  //pour le chart
  late List<TimeDataModel> timeChartData = timeSerie.getTimeSerieModel();

  bool recording = false;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  //nombre de données entrées par enregistrement
  int nbEntries = 0;

  //User data
  late User user;
  late String uid;

  final List<StreamSubscription<dynamic>> _streamSubscriptions = <StreamSubscription<dynamic>>[];


  final _controller = TimeSeriesUpdateController();





  ///Fonction qui permets de récupérer les données de l'utilisateur connecté
  void getUserData() async {
    //Récupération de l'user authentifié
    final user = auth.currentUser;
    //Récupération de l'id de l'utilisateur authentifié
    uid = user!.uid;

    //Avec l'authentification firebase, on peut récupérer les 2 données associées
    //à un utilisateur qui sont l'uid et l'email de l'utilisateur
    //print(uid);
    //print(user.email);

    //exemple: Récupération du firstName de l'user authentifié
    DocumentReference documentReference =
        _firebaseFirestore.collection('users').doc(user.email);
    DocumentSnapshot documentSnapshot = await documentReference.get();
    if (documentSnapshot.exists) {
      String firstName = documentSnapshot.get('firstName');
      print("-----------------------");
      print(firstName);
      print("-----------------------");
    }
  }

  @override
  void initState() {
    getUserData();

    timeSerie = TimeSerieModel(uid);

    _streamSubscriptions
        .add(accelerometerEvents.listen((AccelerometerEvent event) {
      xAcc = event.x;
      yAcc = event.y;
      zAcc = event.z;
      //rebuild the widget
      setState(() {});
    }));

    _streamSubscriptions.add(gyroscopeEvents.listen((GyroscopeEvent event) {
      xGyr = event.x;
      yGyr = event.y;
      zGyr = event.z;
      setState(() {});
    }));

    super.initState();
  }

  ///Fonction appelée lorsque l'on quitte l'écran
  ///
  ///on enlève l'enregistrement des capteurs pour ne pas qu'ils tournent dans le background
  @override
  void dispose() {
    _controller.dispose();


    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Data Collection"),
        ),
        body: Center(
          child: Column(children: [
            ElevatedButton(
              onPressed: recording
                  ? null
                  : () {
                      recording = true;
                      setState(() {});
                      timeSerie.setTime(DateTime.now());
                      //on ajoute une donnée toute les 50ms
                      timer =
                          Timer.periodic(Duration(milliseconds: 50), (Timer t) {
                        timeSerie.addTimeDataModel(TimeDataModel.withAll(
                            t: DateTime.now().microsecondsSinceEpoch,
                            ax: xAcc,
                            ay: yAcc,
                            az: zAcc,
                            gx: xGyr,
                            gy: yGyr,
                            gz: zGyr));
                        nbEntries++;
                      });
                    },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                primary: Theme.of(context).primaryColor,
              ),
              child: Text(
                'Record'.toUpperCase(),
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: !recording
                  ? null
                  : () {
                      recording = false;
                      timeChartData = timeSerie.getTimeSerieModel(); //a enlever ?
                      int duration=timeSerie.setDuration(DateTime.now());

                      setState(() {});
                      Fluttertoast.showToast(
                        msg: 'Recording ended with $nbEntries entries and $duration seconds',
                        fontSize: 18,
                      );
                      timer.cancel();
                      nbEntries = 0;
                      //On va au screen pour sélectioner le label et on passe timeSerie en paramètre pour pourvoir ensuite l'envoyer
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  LabelizeScreen(timeSerie: timeSerie)),
                          (route) => false);
                    },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                primary: Theme.of(context).primaryColor,
              ),
              child: Text(
                'STOP'.toUpperCase(),
                style: TextStyle(color: Colors.white),
              ),
            ),
            Container(
                height: 300,
                child: DynamicTimeSeriesWidget(
                    updateController: _controller,
                    inputChartData: timeChartData)),

            /*Container(
              height: 200,
              child: TimeSeriesChartWidget(),

            ),
            ///https://stackoverflow.com/questions/70820040/how-can-i-display-a-logged-in-user-details-in-flutter do this !!!
             */
          ]),
        ),
      ),
    );
  }



}



