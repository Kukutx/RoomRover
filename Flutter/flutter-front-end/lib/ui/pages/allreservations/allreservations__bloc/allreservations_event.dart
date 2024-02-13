part of 'allreservations_bloc.dart';
sealed class AllReservationsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class OnInitial extends AllReservationsEvent {}

class BookingClickedEvent extends AllReservationsEvent {}

class BookNowButtonClickedEvent extends AllReservationsEvent {}
