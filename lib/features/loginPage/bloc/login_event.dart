part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class LoginInitialEvent extends LoginEvent{
  final String email;
  final String password;

  LoginInitialEvent({required this.email, required this.password});
}