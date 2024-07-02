import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final fireStore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  Future<void> registerUser(
      {required String email,
      required String password,
      required String name}) async {
    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      await fireStore
          .collection("Users")
          .doc(credential.user!.uid)
          .set({"name": name, "email": email, "uid": credential.user!.uid});
      print("Registered Successfully");
    } catch (e) {
      print(e.toString());
    }
  }

  Future<bool> loginUser(
      {required String email, required String password}) async {
    if (email.isEmpty || password.isEmpty) {
      print("Email and password must not be empty");
      return false;
    }

    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      print("LogIn Successful");
      return true;
    } catch (e) {
      print("Error: ${e.toString()}");
      return false;
    }
  }

  Future<void> logOut() async {
    await auth.signOut();
  }


}
