part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent {}

class ChatInitialEvent extends ChatEvent {
  final String receiverUid;

  ChatInitialEvent({required this.receiverUid});
}

class SentChatEvent extends ChatEvent {
  final String receiverUid;
  final String content;

  SentChatEvent({required this.receiverUid, required this.content});
}

class ImageSelectEvent extends ChatEvent {
  final String receiverUid;

  ImageSelectEvent({required this.receiverUid});
}
