import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/service/chatService.dart';
import 'package:meta/meta.dart';

import '../../../model/chatModel.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {

    on<SentChatEvent>(sentChatEvent);
  }


  FutureOr<void> sentChatEvent(
      SentChatEvent event, Emitter<ChatState> emit) async {
    await ChatService()
        .sendMessage(receiverUid: event.receiverUid, content: event.content);


    emit(ChatSentState());

  }
}
