part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class OnHomeInitial extends HomeEvent {}

class OnImageClicked extends HomeEvent {
  final Building building;

  OnImageClicked(this.building);

  @override
  List<Object?> get props => [building];
}
