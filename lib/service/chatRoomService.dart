import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> createRoom({required String roomName}) async {
    try {
      await firestore.collection('rooms').doc(roomName).set({

      });
      print("Room Created: $roomName");
    } catch (e) {
      print("Error creating room: ${e.toString()}");
      throw Exception("Failed to create room: $roomName");
    }
  }
}
