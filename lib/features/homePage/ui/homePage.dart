import 'package:chat_app/features/chatPage/ui/chatPage.dart';
import 'package:chat_app/features/loginPage/ui/loginPage.dart';
import 'package:chat_app/service/authService.dart';
import 'package:chat_app/service/chatRoomService.dart';
import 'package:chat_app/service/userService.dart';
import 'package:chat_app/util/texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/home_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(HomeInitialLoadedEvent()),
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is LogOutActionState) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            switch (state.runtimeType) {
              case LoadedDataState:
                final loadedState = state as LoadedDataState;
                final roomController = TextEditingController();
                return Scaffold(
                  appBar: AppBar(
                    title:     Text(loadedState.data!["name"].toString()),
                    automaticallyImplyLeading: false,
                    actions: [
                      InkWell(
                        onTap: () {
                          context.read<HomeBloc>().add(LogOutEvent());
                        },
                        child: Text(
                          "Log out",
                          style: Texts().Stext,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  body: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
Expanded(
  child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1,
  childAspectRatio: 4),
      itemCount: loadedState.userData.length,
      itemBuilder: (context,index){
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>
        ChatPage(user: loadedState.userData[index],)));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        child: ListTile(
          tileColor: Colors.grey.withOpacity(0.4),
          title: Text(loadedState.userData[index].name),
        ),
      ),
    );
      }),
),
                        ElevatedButton(
                          onPressed: () {
                            _showDialog(context, roomController);
                          },
                          child: Text("Create Chat room"),
                        ),
                      ],
                    ),
                  ),
                );

              case LoadingState:
                return CircularProgressIndicator();

              default:
                return SizedBox(
                  child: Text("Error"),
                );
            }
          },
        ),
      ),
    );
  }

  _showDialog(BuildContext context, TextEditingController controller) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 200,
              width: 300,
              child: Column(
                children: [
                  TextFormField(
                    controller: controller,
                    decoration: InputDecoration(
                        hintText: "Room Name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      ElevatedButton(onPressed: () async{
                        await ChatRoomService().createRoom(roomName: controller.text);
                      }, child: Text("Create")),
                      const SizedBox(
                        width: 5,
                      ),
                      ElevatedButton(onPressed: () async{
                        await UserService().fetchAllUsers();
                      }, child: Text("fetch")),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
