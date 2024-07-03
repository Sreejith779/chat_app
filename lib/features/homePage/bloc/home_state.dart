part of 'home_bloc.dart';

@immutable
abstract class HomeState {}
abstract class HomeActionState extends HomeState{}

  class HomeInitial extends HomeState {}

class LogOutActionState extends HomeState{}
class LoadingState extends HomeState{}

class LoadedDataState extends HomeState{
  final Map<String,dynamic>? data;

  LoadedDataState({required this.data});
}

class CreateRoomState extends HomeActionState{}
