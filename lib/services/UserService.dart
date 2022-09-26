import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/UserModel.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Stream<UserModel> get user {
    return _auth.authStateChanges().asyncMap((user) => UserModel.c(
          uid: user!.uid,
          email: user.email.toString(),
        ));
  }

  Future<UserModel> login(UserModel userModel) async {
    print(userModel.toJson());
    UserCredential userCredential;
    userCredential = await _auth.signInWithEmailAndPassword(
      email: userModel.email,
      password: userModel.password,
    );

    userModel.setUid = userCredential.user!.uid;
    return userModel;
  }

  Future<UserModel> register(UserModel userModel) async {
    print(userModel.toJson());
    UserCredential userCredential;
    userCredential = await _auth.createUserWithEmailAndPassword(
      email: userModel.email,
      password: userModel.password,
    );

    userModel.setUid = userCredential.user!.uid;
    return userModel;
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
