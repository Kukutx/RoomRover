part of 'layout_bloc.dart';
sealed class LayoutEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class OnInitial extends LayoutEvent {}

class LogoutClicked extends LayoutEvent {}