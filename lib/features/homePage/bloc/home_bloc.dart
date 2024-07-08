import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/service/authService.dart';
import 'package:chat_app/service/userService.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/userModel.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LogOutEvent>(logOutEvent);
    on<HomeInitialLoadedEvent>(homeInitialLoadedEvent);
    on<CreateRoom>(createRoom);
  }

  FutureOr<void> logOutEvent(LogOutEvent event, Emitter<HomeState> emit) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("isLogin", false);
    await AuthService().logOut();
    emit(LogOutActionState());

  }

  FutureOr<void> homeInitialLoadedEvent(HomeInitialLoadedEvent event, Emitter<HomeState> emit) async{
    emit(LoadingState());
    try{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setBool("isLogin", true);
      Map<String,dynamic>? data = await UserService().currentUserData();

      final List<Map<String,dynamic>>userData = await UserService().fetchAllUsers();
      List<UserModel>userDatas = userData.map((e) => UserModel(uid: e["uid"], name: e["name"], email: e["email"])).toList();
      emit(LoadedDataState(data: data, userData: userDatas));

    }catch(e){
      print(e.toString());
    }

  }

  FutureOr<void> createRoom(CreateRoom event, Emitter<HomeState> emit) {
    emit(CreateRoomState());
  }
}
