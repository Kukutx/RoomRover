part of 'layout_bloc.dart';

abstract class LayoutState {}

class LayoutInitial extends LayoutState {}

class LayoutLoading extends LayoutState {}

class LayoutLoaded extends LayoutState {
  final Uint8List pic;
  LayoutLoaded(this.pic);
}

class LayoutError extends LayoutState {
  final String error;
  LayoutError(this.error);
}

class LogoutClickedState extends LayoutState {}