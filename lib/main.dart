import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:recognition/screens/Guest/Guest.dart';
import 'package:recognition/screens/Guest/LoginScreen.dart';
import 'package:recognition/screens/Guest/RegisterScreen.dart';
import 'package:recognition/screens/HomeScreen.dart';
import 'package:recognition/screens/LabelizeScreen.dart';
import 'package:recognition/screens/dataCollectionScreen.dart';
// Import the generated file
import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //connexion au projet firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

///L'application est stateful et non stateless
///
///En effet on veut stocker l'état de connection et ainsi renvoyer soit l'écran de connexion
///soit l'écran d'accueil, on pourrait également utiliser des routes dans le futur
class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool connected = false;

  @override
  void initState() {
    //Permets de savoir si l'utilisateur est connecté ou non, on mets ensuite à jour l'attribut connected
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      connected = true;
      setState(() {});
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Activity Recognition App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: connected ? HomeScreen() : GuestScreen(),
    );
  }
}
