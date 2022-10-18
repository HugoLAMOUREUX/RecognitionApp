import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recognition/screens/Guest/Guest.dart';
import 'package:recognition/widgets/userHistoryWidget.dart';
import 'package:recognition/screens/dataCollectionScreen.dart';
import 'package:recognition/services/UserService.dart';

///Écran lancé après une connexion
///
///Il affiche un historique des activités enregistrés, permets d'enregistrer une nouvelle
///activité, permets de se déconnecter et de modifier les paramètres(encore à coder)
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Instance de FireBaseAuth pour le système d'authentification firebase
  final FirebaseAuth auth = FirebaseAuth.instance;
  //Instance de FireBaseFirestore pour lea base de donnéees firebase
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  //Data du user connecté
  late User user;
  late String uid;

  final UserService _userService = UserService();

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, //pour cacher la flèche arrière
          title: Text("Welcome user.displayName"), //en attendant de trouver un moyen d'afficher le displayname
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
              onPressed: (() async {
                await _userService.logout();
                ///TROUVER UNE SOLLUTION AU PROBLEME : Do not use BuildContexts across async gaps.
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => GuestScreen()),
                        (route) => false);
              }),
            )
          ],
        ),
        body: Center(
          child: Column(
            children: [
          /*    ElevatedButton(
                onPressed: (() async {
                  //Déconnexion
                  await _userService.logout();
                  //Retour à l'écran de connexion
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => GuestScreen()),
                      (route) => false);
                }),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),*/
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                onPressed: (() {
                  //Passage à l'écran de collection de données
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DataCollectionScreen()));
                }),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                ),
                child: const Text(
                  'Start an activity',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              UserHistoryWidget()

            ],
          ),
        ),
      ),
    );
  }
}
