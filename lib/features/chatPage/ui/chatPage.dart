import 'package:chat_app/model/userModel.dart';
import 'package:chat_app/service/chatRoomService.dart';
import 'package:chat_app/service/chatService.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/chat_bloc.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key, required this.user});
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final messageController = TextEditingController();
    return BlocProvider(
  create: (context) => ChatBloc()..add(ChatInitialEvent(receiverUid: user.uid)),
  child: BlocBuilder<ChatBloc, ChatState>(
  builder: (context, state) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end
          ,
          children: [
            if(state is ChatSentState)
              Center(
                child: CircularProgressIndicator(),
              ),
            if(state is ChatLoadedState)
Expanded(
  child: ListView.builder(
      itemCount: state.chats.length,
      itemBuilder: (context,index){
        final isSender = state.chats[index].senderId != user.uid;
    return  BubbleSpecialThree(text: state.chats[index].content,
    isSender: isSender,
    );
  }),
),
            Row(
              children: [
                Expanded(
                  child: Container(
                    width: double.maxFinite,
                    height: MediaQuery.of(context).size.height*0.09,
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(15),
                     color: Colors.grey.withOpacity(0.4),
                   ),
                    child: TextField(
                      controller: messageController,
                      decoration: const InputDecoration(
                        hintText: "Message",
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none
                        )
                      ),
                    ),
                  ),
                ),
                IconButton(onPressed: ()async{
                  if (messageController.text.isNotEmpty) {

                    context.read<ChatBloc>().add(SentChatEvent(receiverUid: user.uid, content: messageController.text));

                    messageController.clear();
                  }
                },
                    icon: Icon(Icons.send),color: Colors.blue,iconSize: 30,)
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
