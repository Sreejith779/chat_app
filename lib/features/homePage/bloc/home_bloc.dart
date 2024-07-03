import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/service/authService.dart';
import 'package:chat_app/service/userService.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LogOutEvent>(logOutEvent);
    on<HomeInitialLoadedEvent>(homeInitialLoadedEvent);
    on<CreateRoom>(createRoom);
  }

  FutureOr<void> logOutEvent(LogOutEvent event, Emitter<HomeState> emit) async{
    await AuthService().logOut();
    emit(LogOutActionState());

  }

  FutureOr<void> homeInitialLoadedEvent(HomeInitialLoadedEvent event, Emitter<HomeState> emit) async{
emit(LoadingState());
    Map<String,dynamic>? data = await UserService().currentUserData();
    emit(LoadedDataState(data: data));
  }

  FutureOr<void> createRoom(CreateRoom event, Emitter<HomeState> emit) {
    emit(CreateRoomState());
  }
}
