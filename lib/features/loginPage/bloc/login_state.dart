part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

abstract class LoginActionState extends LoginState {}

class LoginInitial extends LoginState {}

class LoginLoadingActionState extends LoginActionState {}

class LoginLoadedState extends LoginState {}

class LoginErrorActionState extends LoginActionState {}
