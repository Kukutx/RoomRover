part of 'roommap_bloc.dart';

@immutable
abstract class RoomMapState extends Equatable {}

class RoomMapInitial extends RoomMapState {
  @override
  List<Object?> get props => [];
}

class RoomMapLoading extends RoomMapState {
  @override
  List<Object?> get props => [];
}

class RoomMapLoaded extends RoomMapState {
  final List<ResourceModel> resourceDataList;

  RoomMapLoaded(
    this.resourceDataList,
  );
  @override
  List<Object?> get props => [resourceDataList];
}

class Error extends RoomMapState {
  final String error;

  Error(this.error);
  @override
  List<Object?> get props => [error];
}