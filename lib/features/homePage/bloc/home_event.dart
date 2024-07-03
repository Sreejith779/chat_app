part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class LogOutEvent extends HomeEvent{}

class HomeInitialLoadedEvent extends HomeEvent{}
class CreateRoom extends HomeEvent{}
