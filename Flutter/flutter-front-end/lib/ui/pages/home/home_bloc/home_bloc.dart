import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:pw5/data/repositories/buildings_repository.dart';
import 'package:pw5/domain/models/building_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final BuildingsRepository buildingsRepository;
  static var log = Logger();
  HomeBloc({required this.buildingsRepository}) : super(HomeInitial()) {
    on<OnHomeInitial>((event, emit) async {
      emit(HomeLoading());
      String error = "";
      try {
        await buildingsRepository.getMyBuildings().then((buildingsDataList) {
          for (var building in buildingsDataList) {
            if (building.imageLink.isEmpty) {
              emit(ImageError(building.imageLink));
            }
          }

          emit(HomeLoaded(buildingsDataList));
        });
      } catch (e) {
        error = e.toString();
        log.d("ho trovato errore durante loading del Home");
        emit(Error(error));
      }
    });

    on<OnImageClicked>((event, emit) async {
      Building clickedBuilding = event.building;
      emit(ImageClicked(clickedBuilding));
    });
  }
}
