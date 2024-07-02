import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final auth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance;

  Future<User?> getCurrentUser() async {
    return auth.currentUser;
  }

  Future<List<QueryDocumentSnapshot<Object?>>> getCurrentUserData() async {
    User? currentUser = await getCurrentUser();

    try {
      if (currentUser != null) {
        QuerySnapshot querySnapshot =
        await fireStore.collection("Users").doc(currentUser.uid).collection("Users").get();
        return querySnapshot.docs;
      } else {
        throw FirebaseAuthException(
          code: 'user-not-found',

        );
      }
    } catch (e) {
      print(e.toString());
      throw e; // Ensure to re-throw the exception to propagate it
    }
  }
}
