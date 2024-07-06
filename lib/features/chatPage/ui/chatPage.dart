import 'package:chat_app/model/userModel.dart';
import 'package:chat_app/service/chatService.dart';
import 'package:chat_bubbles/bubbles/bubble_normal_image.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../model/chatModel.dart';
import '../bloc/chat_bloc.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key, required this.user});
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final messageController = TextEditingController();
    return BlocProvider(
      create: (context) => ChatBloc(),
      child: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(user.name),
            ),
            body: Container(
              margin: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: StreamBuilder<List<ChatModel>>(
                      stream: ChatService().fetchMessage(receiverId: user.uid),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<ChatModel>> snapshot) {
                         var uuid = Uuid();
                         final v4 = uuid.v4();
                        if (snapshot.hasData) {
                          List<ChatModel> messages = snapshot.data!;
                          return ListView.builder(
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              bool isSender =
                                  snapshot.data![index].receiverId == user.uid;
                              return 
                              snapshot.data![index].imageUrl !=null?
                                  BubbleNormalImage(id: v4,
                                      color: Colors.transparent,
                                      image: Image.network(snapshot.data![index].imageUrl.toString(),)):

                                BubbleSpecialThree(
                                  isSender: isSender,
                                  color: isSender
                                      ? Color(0xFF1B97F1)
                                      : Color(0xFFE8E8EE),
                                  tail: false,

                                  text:
                                  snapshot.data![index].content);
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Center(child: Text("Something went wrong"));
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: double.maxFinite,
                          height: MediaQuery.of(context).size.height * 0.075,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey.withOpacity(0.4),
                          ),
                          child: TextField(
                            controller: messageController,
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      context
                                          .read<ChatBloc>()
                                          .add(ImageSelectEvent(receiverUid: user.uid));
                                    },
                                    icon: const Icon(Icons.image)),
                                hintText: "Message",
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none)),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          if (messageController.text.isNotEmpty) {
                            context.read<ChatBloc>().add(SentChatEvent(
                                receiverUid: user.uid,
                                content: messageController.text));

                            messageController.clear();
                          }
                        },
                        icon: Icon(Icons.send),
                        color: Colors.blue,
                        iconSize: 30,
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
