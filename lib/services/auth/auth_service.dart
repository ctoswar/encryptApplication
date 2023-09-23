import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:firebase_core/firebase_core.dart';

class AuthService extends ChangeNotifier {
  //instance
  final FirebaseAuth _firebase = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Map<String, dynamic> keysData;

  AuthService(this.keysData);

  //sign in
  Future<UserCredential> signInWithEmailandPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _firebase
          .signInWithEmailAndPassword(email: email, password: password);

      _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'username': email.split("@")[0],
        'bio': 'empty bio'
      }, SetOptions(merge: true));
      return userCredential;
    } on FirebaseAuthException catch (ex) {
      throw Exception(ex.code);
    }
  }

  //create user
  Future<UserCredential> signUpwtihEmailandPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebase.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      //documents
      _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'username': email.split("@")[0],
        'bio': 'empty bio'
      });
      return userCredential;
    } on FirebaseAuthException catch (ex) {
      throw Exception(ex.code);
    }
  }

  //signout
  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }
}
