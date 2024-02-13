part of 'allreservations_bloc.dart';

abstract class AllReservationsState extends Equatable {}

class Initial extends AllReservationsState {
  @override
  List<Object?> get props => [];
}

class Loading extends AllReservationsState {
  @override
  List<Object?> get props => [];
}

class Loaded extends AllReservationsState {
  final List<Booking> yourBookings;

  Loaded(this.yourBookings,);
  @override
  List<Object?> get props => [yourBookings];
}

class Error extends AllReservationsState {
  final String error;

  Error(this.error);
  @override
  List<Object?> get props => [error];
}
class ReservationClicked extends AllReservationsState {
  final Booking bookingClicked;

  ReservationClicked(this.bookingClicked);
  @override
  List<Object?> get props => [];
}

class BookingClicked extends AllReservationsState{
  @override
  List<Object?> get props => [];
}
class BookNowClicked extends AllReservationsState {
  @override
  List<Object?> get props => [];
}
