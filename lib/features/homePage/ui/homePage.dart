import 'package:chat_app/features/loginPage/ui/loginPage.dart';
import 'package:chat_app/service/authService.dart';
import 'package:chat_app/service/userService.dart';
import 'package:chat_app/util/texts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/home_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(),
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
       switch(state.runtimeType){
         case LogOutActionState:
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>
           LoginPage()));
       }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
final data =
            
            return Scaffold(
              appBar: AppBar(
                title: Text("ChatApp"),
                automaticallyImplyLeading: false,
                actions: [
                  InkWell(
                      onTap: () {
                        context.read<HomeBloc>().add(LogOutEvent());
                      },
                      child: Text("Log out", style: Texts().Stext,)),
                  const SizedBox(
                    width: 10,
                  )
                ],
              ),
              body: Container(
                child: Column(
                  children: [

                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
