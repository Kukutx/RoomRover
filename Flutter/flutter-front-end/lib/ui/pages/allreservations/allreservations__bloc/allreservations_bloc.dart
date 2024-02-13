import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:pw5/data/repositories/bookings_repository.dart';
import 'package:pw5/domain/models/booking_model.dart';
import 'package:pw5/domain/models/filters_model.dart';

part 'allreservations_event.dart';
part 'allreservations_state.dart';

class AllReservationsBloc extends Bloc<AllReservationsEvent, AllReservationsState> {
  final BookingsRepository bookingsRepository;
  final Filters filters;
  static var log = Logger();
  AllReservationsBloc({required this.bookingsRepository, required this.filters}) : super(Initial()) {
    
    on<OnInitial>((event, emit) async {
      emit(Loading());
      String error = "";
      try {
        await bookingsRepository.getMyBookingsWithFilters(filters).then((yourBookings) {
          emit(Loaded(yourBookings));
        });
      } catch (e) {
        error = e.toString();
        log.d("ho trovato errore durante loading my bookings with filters");
        emit(Error(error));
      }
    });

    on<BookingClickedEvent>((event, emit) async {
      emit(BookingClicked());
    });

    on<BookNowButtonClickedEvent>((event, emit) async {
      emit(BookNowClicked());
    });

  }
}
