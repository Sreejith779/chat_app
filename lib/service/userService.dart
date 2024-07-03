import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final auth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance;

  Future<User?> getCurrentUser() async {
    return auth.currentUser;
  }

  Future<Map<String,dynamic>?>currentUserData()async{
     final currentUser = await getCurrentUser();


     try{
       DocumentSnapshot documentSnapshot =
       await fireStore.collection("Users").doc(currentUser!.uid).get();
       return documentSnapshot.data() as Map<String,dynamic>?;
     }
    catch(e){
       print(e.toString());
    }

  }
}
