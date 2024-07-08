import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/service/chatService.dart';
import 'package:chat_app/service/imageService.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';


part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<SentChatEvent>(sentChatEvent);
    on<ImageSelectEvent>(imageSelectEvent);
  }

  FutureOr<void> sentChatEvent(
      SentChatEvent event, Emitter<ChatState> emit) async {
    await ChatService()
        .sendMessage(receiverUid: event.receiverUid, content: event.content);

    emit(ChatSentState());
  }

  FutureOr<void> imageSelectEvent(
      ImageSelectEvent event, Emitter<ChatState> emit) async {

    ImagePicker imagePicker = ImagePicker();
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      print("image selected : ${image.path}");

      final imageUrl = await ImageService().uploadImage(imagePath: image.path);
      await ChatService().sendMessage(receiverUid: event.receiverUid, content: "",imageUrl: imageUrl);

print("image uploaded Sucessfully");
    } else {
      print("image not selected");
    }



  }
}
