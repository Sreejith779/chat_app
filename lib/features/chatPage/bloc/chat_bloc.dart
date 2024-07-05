import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/service/chatService.dart';
import 'package:meta/meta.dart';

import '../../../model/chatModel.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<ChatInitialEvent>(chatInitialEvent);
    on<SentChatEvent>(sentChatEvent);
  }

  FutureOr<void> chatInitialEvent(
      ChatInitialEvent event, Emitter<ChatState> emit) async {
    final List<ChatModel> chat =
        await ChatService().fetchMessages(receiverUid: event.receiverUid);
    print(chat);
    emit(ChatLoadedState(chats: chat));
  }

  FutureOr<void> sentChatEvent(
      SentChatEvent event, Emitter<ChatState> emit) async {
    await ChatService()
        .sendMessage(receiverUid: event.receiverUid, content: event.content);

    final List<ChatModel> chat =
        await ChatService().fetchMessages(receiverUid: event.receiverUid);
    emit(ChatSentState());
    emit(ChatLoadedState(chats: chat));
  }
}
