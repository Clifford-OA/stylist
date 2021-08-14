import 'package:stylist/auth/userData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class AuthClass with ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference usersColRef =
      FirebaseFirestore.instance.collection('users');

  CollectionReference stylistPeople =
      FirebaseFirestore.instance.collection('stylists');

  Future<Map> createAccount(
      UserData userData, String email, String password) async {
    Map authStatus = {
      'status': false,
      'message': 'initialized message',
    };
    try {
      final result = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      userData.tid = result.user!.uid;
      userData.email = result.user!.email!;

      authStatus['status'] = true;
      authStatus['message'] = 'Account created';
      notifyListeners();
      return authStatus;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        authStatus['message'] = 'The password provided is too weak.';
        notifyListeners();
        return authStatus;
      } else if (e.code == 'email-already-in-use') {
        authStatus['message'] = 'The account already exists for that email.';
        notifyListeners();
        return authStatus;
      }
    } catch (e) {
      authStatus['message'] = "Error Occurred";
      notifyListeners();
      return authStatus;
    }

    return authStatus;
  }

  //Sign in user
  Future<Map> signIN(UserData userData, String email, String password) async {
    Map authStatus = {
      'status': false,
      'message': '',
    };
    try {
      final result = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      userData.tid = result.user!.uid;
      authStatus['status'] = true;
      notifyListeners();
      return authStatus;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        authStatus['message'] = 'No user found for that email.';
        return authStatus;
      } else if (e.code == 'wrong-password') {
        authStatus['message'] = 'Wrong password provided for that user.';
        return authStatus;
      }
    }

    return authStatus;
  }

  //Reset Password
   Future<Map> resetPassword(String email) async {

     Map authStatus = {
      'status': false,
      'message': '',
    };
    try {
      await auth.sendPasswordResetEmail(
        email: email,
      );
      authStatus['status'] = true;
      return authStatus;
    } catch (e) {
      authStatus['message'] = '$e';
      return authStatus;
    }
  }

  //SignOut
  void signOut() async {
    await auth.signOut();
  }

// Must go to the stylist class 
  
}
