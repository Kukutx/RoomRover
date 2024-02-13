part of 'login_bloc.dart';

abstract class LoginState extends Equatable {}

class Initial extends LoginState {
  @override
  List<Object?> get props => [];
}

class CheckingToken extends LoginState {
  @override
  List<Object?> get props => [];
}

class ErrorLogin extends LoginState {
  final String error;
  ErrorLogin(this.error);

  @override
  List<Object?> get props => [error];
}

class ErrorCheck extends LoginState {
  @override
  List<Object?> get props => [];
}

class HasToken extends LoginState {
  final String token;
  HasToken(this.token);

  @override
  List<Object?> get props => [];
}

class HasNotToken extends LoginState {
  @override
  List<Object?> get props => [];

  get error => null;
}

class IsLoggingIn extends LoginState{
  @override
  List<Object?> get props => [];
}