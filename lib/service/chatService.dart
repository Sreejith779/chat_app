import 'package:chat_app/model/chatModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class ChatService {
  final fireStore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  Future<void> sendMessage({
    required String receiverUid,
    required String content,
    String? imageUrl
  }) async {
    final currentUser = auth.currentUser;
    try {
      await fireStore.collection("Messages").add({
        "senderId": currentUser!.uid,
        "receiverId": receiverUid,
        "content": content,
        "imageUrl": imageUrl,
        "time": FieldValue.serverTimestamp(),
      });
      print("Message sent Successfully");
    } catch (e) {
      print("MESSAGE FAILED");
      print(e.toString());
    }
  }

  Stream<List<ChatModel>> fetchMessage({required String receiverId}) {
    final currentUser = auth.currentUser;

    Stream<QuerySnapshot<Map<String, dynamic>>> sendMessages = fireStore
        .collection("Messages")
        .where("senderId", isEqualTo: currentUser!.uid)
        .where("receiverId", isEqualTo: receiverId)
        .snapshots();

    Stream<QuerySnapshot<Map<String, dynamic>>> receivedMessages = fireStore
        .collection("Messages")
        .where("receiverId", isEqualTo: currentUser.uid)
        .where("senderId", isEqualTo: receiverId)
        .snapshots();

    return Rx.combineLatest2(sendMessages, receivedMessages,
            (QuerySnapshot<Map<String, dynamic>> sendMessages,

            QuerySnapshot<Map<String, dynamic>> receivedMessages) {
          final List<ChatModel> messages = [];
          sendMessages.docs.forEach((element) {
            messages.add(ChatModel.fromMap(element.data()));
          });
          receivedMessages.docs.forEach((element) {
            messages.add(ChatModel.fromMap(element.data()));
          });

          messages.sort((a, b) => a.time.compareTo(b.time));
          return messages;
        });
  }
}
