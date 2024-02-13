part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {}

class Initial extends ProfileState {
  @override
  List<Object?> get props => [];
}

class Loading extends ProfileState {
  @override
  List<Object?> get props => [];
}

class Loaded extends ProfileState {
  final List<Booking> fourBookings;
  final User profile;
  final Uint8List immagine;
  final String errorProfile;
  final String errorBooking;
  final String erroreImmagine;

  Loaded(this.errorProfile,this.errorBooking,this.fourBookings,this.immagine, this.profile,this.erroreImmagine);
  @override
  List<Object?> get props => [errorProfile,errorBooking,fourBookings,profile,immagine,erroreImmagine];
}

class ReservationClicked extends ProfileState {
  final Booking bookingClicked;

  ReservationClicked(this.bookingClicked);
  @override
  List<Object?> get props => [];
}

class ViewAllButtonClicked extends ProfileState {
  @override
  List<Object?> get props => [];
}

/*class BookingClicked extends ProfileState{
  @override
  List<Object?> get props => [];
}*/
class BookNowClicked extends ProfileState {
  @override
  List<Object?> get props => [];
}
