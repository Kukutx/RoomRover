import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:pw5/data/repositories/auth_repository.dart';
import 'package:pw5/data/repositories/bookings_repository.dart';
import 'package:pw5/domain/models/booking_model.dart';
import 'package:pw5/domain/models/link_immagine_model.dart';
import 'package:pw5/domain/models/user_model.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepository authRepository;
  final BookingsRepository bookingsRepository;
  static var log = Logger();
  void resetState() {
    add(OnInitial());
  }
  ProfileBloc({required this.authRepository, required this.bookingsRepository})
      : super(Initial()) {
    on<OnInitial>((event, emit) async {
      emit(Loading());
      User profil = User(
          businessPhones: [],
          displayName: "",
          givenName: "",
          jobTitle: "",
          mail: "",
          officeLocation: "",
          preferredLanguage: "",
          surname: "",
          userPrincipalName: "",
          id: "");
      Uint8List pic = Uint8List(0);
      List<Booking> fourBookings = [];
      String errorProfile = "";
      String errorBookings = "";
      String erroreImmagine = "";
      try {
        await authRepository.getProfile().then((profilo) {
          profil = profilo;
        });
      } catch (e) {
        errorProfile = e.toString();
      }
      try {
        await authRepository.getImmagine().then((immagine) {
          pic = immagine;
        });
      } catch (e) {
        erroreImmagine = e.toString();
      }
      try {
        await bookingsRepository.getMyFirstFourBookings().then((bookings) {
          fourBookings = bookings;
        });
      } catch (e) {
        errorBookings = e.toString();
        log.d(e.toString());
      }
      //forse devo metterlo nel try sopra e anche nel catch
      emit(Loaded(errorProfile, errorBookings, fourBookings, pic, profil,erroreImmagine));
    });

    on<ViewAllButtonClickedEvent>((event, emit) async {
      emit(ViewAllButtonClicked());
    });

    /*on<BookingClickedEvent>((event, emit) async {
      emit(BookingClicked());
    });*/

    on<BookNowButtonClickedEvent>((event, emit) async {
      emit(BookNowClicked());
    });
  }
}
