import 'package:chat_app/model/chatModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final fireStore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  Future<void> sendMessage({
    required String receiverUid,
    required String content,
  }) async {
    final currentUser = auth.currentUser;
    try {
      await fireStore.collection("Messages").add({
        "senderId": currentUser!.uid,
        "receiverId": receiverUid,
        "content": content,
        "time": FieldValue.serverTimestamp(),
      });
      print("Message sent Successfully");
    } catch (e) {
      print("MESSAGE FAILED");
      print(e.toString());
    }
  }

  Future<List<ChatModel>> fetchMessages({required String receiverUid}) async {
    final List<ChatModel> messages = [];
    final currentUser = auth.currentUser;
    try {
      // Fetch messages where the current user is the sender
      QuerySnapshot<Map<String, dynamic>> sentMessagesSnapshot = await fireStore
          .collection("Messages")
          .where("senderId", isEqualTo: currentUser!.uid)
          .where("receiverId", isEqualTo: receiverUid)
          .get();

      sentMessagesSnapshot.docs.forEach((element) {
        messages.add(ChatModel.fromMap(element.data()));
      });

      // Fetch messages where the current user is the receiver
      QuerySnapshot<Map<String, dynamic>> receivedMessagesSnapshot = await fireStore
          .collection("Messages")
          .where("senderId", isEqualTo: receiverUid)
          .where("receiverId", isEqualTo: currentUser.uid)
          .get();

      receivedMessagesSnapshot.docs.forEach((element) {
        messages.add(ChatModel.fromMap(element.data()));
      });

      // Sort messages by time
      messages.sort((a, b) => a.time.compareTo(b.time));
    } catch (e) {
      print(e.toString());
    }
    return messages;
  }
}
