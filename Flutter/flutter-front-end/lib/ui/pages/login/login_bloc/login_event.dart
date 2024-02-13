part of 'login_bloc.dart';
sealed class LoginEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class OnInitial extends LoginEvent {}

class OnLogin extends LoginEvent {}

class OnHasToken extends LoginEvent {}