import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime time;

  ChatModel({
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.time,
  });

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      senderId: map['senderId'],
      receiverId: map['receiverId'],
      content: map['content'],
      time: (map['time'] as Timestamp).toDate(),
    );
  }
}
