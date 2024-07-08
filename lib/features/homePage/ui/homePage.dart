import 'package:chat_app/features/chatPage/ui/chatPage.dart';
import 'package:chat_app/features/loginPage/ui/loginPage.dart';


import 'package:chat_app/service/chatRoomService.dart';
import 'package:chat_app/service/userService.dart';
import 'package:chat_app/util/texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
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
            if (state is LoadedDataState) {
                final loadedState = state as LoadedDataState;
                final roomController = TextEditingController();
                return Scaffold(
                  body: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.24,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/design.png"),
                                  fit: BoxFit.cover,
                                  opacity: 0.2)),
                          margin: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Hello, ${loadedState.data!["name"]}",
                                    style: Texts().Mtext,
                                  ),
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: PopupMenuButton(
                                      color: Colors.white,
                                      itemBuilder:
                                        (BuildContext context)=>
                                      [
                                        PopupMenuItem(child: InkWell(
                                            onTap: (){
                                         context.read<HomeBloc>().add(LogOutEvent());
                                            },
                                            child: Text("Logout")))
                                      ],)

                                  )
                                ],
                              ),
                              Text(
                                DateFormat('h:mm a, EEEE')
                                    .format(DateTime.now()),
                                style: Texts().Dtext.copyWith(fontSize: 24),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 50),
                                child: ElevatedButton(
                                  onPressed: () {
                                    _showDialog(context, roomController);
                                  },
                                  child: Text("Create Chat room"),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30))),
                            child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 1, childAspectRatio: 4),
                                itemCount: loadedState.userData.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ChatPage(
                                                    user: loadedState
                                                        .userData[index],
                                                  )));
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(18)),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                              radius: 30,
                                              backgroundColor:
                                                  Colors.grey.withOpacity(0.4),
                                              child: Icon(
                                                Icons.person,
                                                size: 30,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            loadedState.userData![index].name,
                                            style: Texts().Stext.copyWith(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                      alignment: Alignment.centerLeft,
                                    ),
                                  );
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
            }else{
            return  Scaffold(
            body: Center(
            child: Lottie.asset("assets/loader.json",
            height: 60,width: 60),
            ),
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
                      ElevatedButton(
                          onPressed: () async {
                            await ChatRoomService()
                                .createRoom(roomName: controller.text);
                          },
                          child: Text("Create")),
                      const SizedBox(
                        width: 5,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            await UserService().fetchAllUsers();
                          },
                          child: Text("fetch")),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
