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

  FutureOr<void> loginInitialEvent(
      LoginInitialEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState());
    try {
      bool isLogin = await AuthService()
          .loginUser(email: event.email, password: event.password);
      if (isLogin == true) {

        emit(LoginLoadedState());
      } else {
        emit(LoginErrorActionState());
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
