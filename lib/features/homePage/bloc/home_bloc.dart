import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/service/authService.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LogOutEvent>(logOutEvent);
  }

  FutureOr<void> logOutEvent(LogOutEvent event, Emitter<HomeState> emit) async{
    await AuthService().logOut();
    emit(LogOutActionState());

  }
}
