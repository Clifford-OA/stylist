import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserData extends ChangeNotifier{
  UserData(this.tid, this.email, this.password, this.stylistName, this.saloonName, this.serviceList,this.tel);

  CollectionReference users = FirebaseFirestore.instance.collection('stylists');

  String tid;
  String email;
  String password;
  String stylistName;
  String saloonName;
  List serviceList;
  String tel;

  UserData get userDataRef => UserData(tid, email, password, stylistName, saloonName, serviceList, tel);

  DocumentReference get firestoreRef =>
      FirebaseFirestore.instance.collection('stylists').doc('$tid');

  Future<void> saveInfo() async {
    await firestoreRef.set(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'tid': tid,
      'stylistName': stylistName,
      'email': email,
      'saloonName': saloonName,
      'serviceList': [],
      'imgUrl': '',
      'rateAmount': 20,
      'rating': 3.4,
      'tel': int.parse(tel),
    };
  }
}

