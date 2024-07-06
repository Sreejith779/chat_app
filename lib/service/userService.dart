import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final auth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance;

  Future<User?> getCurrentUser() async {
    return auth.currentUser;
  }

  Future<Map<String, dynamic>?> currentUserData() async {
    final currentUser = await getCurrentUser();

    try {
      DocumentSnapshot documentSnapshot =
          await fireStore.collection("Users").doc(currentUser!.uid).get();
      return documentSnapshot.data() as Map<String, dynamic>?;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllUsers() async {
    final currentUser = await getCurrentUser();



    List<Map<String, dynamic>> data = [];
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await fireStore.collection("Users").get();

      snapshot.docs.forEach((element) {
        if (element.id != currentUser!.uid) {
          data.add(element.data());
          print(data);
        }
      });
      return data;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
