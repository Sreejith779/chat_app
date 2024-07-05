part of 'chat_bloc.dart';

@immutable
abstract class ChatState {}

  class ChatInitial extends ChatState {}

class ChatLoadedState extends ChatState{
  final List<ChatModel>chats;

  ChatLoadedState({required this.chats});
}

class ChatSentState extends ChatState{}
