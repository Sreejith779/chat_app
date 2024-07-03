import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end
          ,
          children: [
            Container(
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height*0.09,
             decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(15),
               color: Colors.grey.withOpacity(0.4),
             ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Messege",
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none
                  )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
