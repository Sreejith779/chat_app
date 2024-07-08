import 'package:chat_app/model/userModel.dart';
import 'package:chat_app/service/chatService.dart';
import 'package:chat_bubbles/bubbles/bubble_normal_image.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
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
            backgroundColor: Colors.white.withOpacity(0.9),
            appBar: AppBar(
              title: Text(user.name),
              backgroundColor: Colors.white.withOpacity(0.8),
            ),
            body: Container(
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
                              return snapshot.data![index].imageUrl != null
                                  ? BubbleNormalImage(
                                  isSender: isSender,
                                      id: v4,
                                      color: Colors.transparent,
                                      image: Image.network(
                                        snapshot.data![index].imageUrl
                                            .toString(),
                                      ))

                                  : BubbleSpecialThree(
                                      isSender: isSender,
                                      color: isSender
                                          ? Colors.black
                                          : Colors.white,
                                      tail: false,
                                      textStyle: TextStyle(
                                        fontSize: 18,
                                          color: isSender
                                              ? Colors.white
                                              : Colors.black),
                                      text: snapshot.data![index].content,
                                    );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return   Center(
                              child:    Lottie.asset(
                                  "assets/loader.json",
                                  height: 60,
                                  width: 60));
                        } else {
                          return Center(
                              child:    Lottie.asset(
                                  "assets/loader.json",
                                  height: 60,
                                  width: 60));
                        }
                      },
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: double.maxFinite,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: double.maxFinite,
                              height:
                                  MediaQuery.of(context).size.height * 0.075,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.grey.withOpacity(0.4),
                              ),
                              child: TextField(
                                controller: messageController,
                                decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          context.read<ChatBloc>().add(
                                              ImageSelectEvent(
                                                  receiverUid: user.uid));
                                        },
                                        icon: Image.asset(
                                          "assets/paper-pin.png",
                                          height: 25,
                                          width: 25,
                                        )),
                                    hintText: "Message",
                                    border: const OutlineInputBorder(
                                        borderSide: BorderSide.none)),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.black,
                            child: IconButton(
                              onPressed: () async {
                                if (messageController.text.isNotEmpty) {
                                  context.read<ChatBloc>().add(SentChatEvent(
                                      receiverUid: user.uid,
                                      content: messageController.text));

                                  messageController.clear();
                                }
                              },
                              icon: Image.asset(
                                "assets/send.png",
                                color: Colors.white,
                                height: 25,
                              ),
                              color: Colors.blue,
                              iconSize: 30,
                            ),
                          ),
                        )
                      ],
                    ),
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
