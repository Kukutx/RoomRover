import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import 'package:pw5/data/repositories/resource_repository.dart';
import 'package:pw5/domain/models/reservation_time_range_model.dart';
import 'package:pw5/domain/models/resource_model.dart';

part 'roommap_event.dart';
part 'roommap_state.dart';

class RoomMapBloc extends Bloc<RoomMapEvent, RoomMapState> {
  final ResourceRepository resourceRepository;
  final ReservationTimeRange reservationTimeRange;
  final int resourceId;
  final bool isMapPositioning;
  static var log = Logger();
  RoomMapBloc(
      {required this.resourceRepository,
      required this.reservationTimeRange,
      this.isMapPositioning = false,
      this.resourceId = 0})
      : super(RoomMapInitial()) {
    on<OnRoomMapInitial>((event, emit) async {
      emit(RoomMapLoading());
      String error = "";
      try {
        if (isMapPositioning) {
          await resourceRepository.getById(resourceId).then((resourceDataList) {
            emit(RoomMapLoaded(resourceDataList));
          });
        } else {
          await resourceRepository
              .getResourceFromRangeDate(reservationTimeRange)
              .then((resourceDataList) {
            emit(RoomMapLoaded(resourceDataList));
          });
        }
      } catch (e) {
        error = e.toString();
        log.d("ho trovato errore durante loading del room map");
        emit(Error(error));
      }
    });
  }
}
