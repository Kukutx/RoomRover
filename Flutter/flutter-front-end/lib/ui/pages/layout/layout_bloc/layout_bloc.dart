import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:pw5/data/repositories/auth_repository.dart';
import 'package:pw5/domain/models/link_immagine_model.dart';

part 'layout_event.dart';
part 'layout_state.dart';

class LayoutBloc extends Bloc<LayoutEvent, LayoutState> {
  final AuthRepository authRepository;
  static var log = Logger();

  LayoutBloc({required this.authRepository}) : super(LayoutInitial()) {
    on<OnInitial>((event, emit) async {
      log.d("layout");
      emit(LayoutLoading());
      try {
        log.d("eseguo chiamata a get profile");
        Uint8List? pic = await authRepository.getImmagine();
        emit(LayoutLoaded(pic));
      }catch (e) {
        log.d("errore get profile catchato");
        emit(LayoutError(e.toString()));
      }
    });
    on<LogoutClicked>((event, emit) async {
      emit(LogoutClickedState());
    });
  }
}