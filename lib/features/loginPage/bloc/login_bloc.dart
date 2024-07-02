import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/service/authService.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
  on<LoginInitialEvent>(loginInitialEvent);
  }

  FutureOr<void> loginInitialEvent(LoginInitialEvent event, Emitter<LoginState> emit) async{


    bool isLogin =  await AuthService().loginUser(email: event.email, password: event.password);
    try{

      if(isLogin == true){
        emit(LoginLoadingActionState());
        emit(LoginLoadedState());
      }
      else{
        emit(LoginErrorActionState());
      }


    }catch(e){

      print(e.toString());
    }

  }
}
