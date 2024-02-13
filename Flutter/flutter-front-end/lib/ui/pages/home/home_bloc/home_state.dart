part of 'home_bloc.dart';

abstract class HomeState extends Equatable {}

class HomeInitial extends HomeState {
  @override
  List<Object?> get props => [];
}

class HomeLoading extends HomeState {
  @override
  List<Object?> get props => [];
}

class HomeLoaded extends HomeState {
  final List<Building> buildingsDataList;

  HomeLoaded(
    this.buildingsDataList,
  );
  @override
  List<Object?> get props => [buildingsDataList];
}

class Error extends HomeState {
  final String error;

  Error(this.error);
  @override
  List<Object?> get props => [error];
}

class ImageClicked extends HomeState {
  final Building building;

  ImageClicked(this.building);

  @override
  List<Object?> get props => [building];
}

class ImageError extends HomeState {
  final String imageUrl;

  ImageError(this.imageUrl);

  @override
  List<Object?> get props => [imageUrl];
}
