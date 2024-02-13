part of 'roommap_bloc.dart';

@immutable
sealed class RoomMapEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class OnRoomMapInitial extends RoomMapEvent {}