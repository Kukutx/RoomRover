part of 'profile_bloc.dart';
sealed class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class OnInitial extends ProfileEvent {}

class ViewAllButtonClickedEvent extends ProfileEvent {}

//class BookingClickedEvent extends ProfileEvent {}

class BookNowButtonClickedEvent extends ProfileEvent {}
