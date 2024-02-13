// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pw5/data/repositories/resource_repository.dart';
import 'package:pw5/domain/models/building_model.dart';
import 'package:pw5/domain/models/reservation_time_range_model.dart';
import 'package:pw5/domain/models/resource_model.dart';
import 'package:pw5/ui/pages/roommap/map_bloc/roommap_bloc.dart';
import 'package:pw5/ui/widgets/roommap_error.dart';
import 'package:pw5/ui/widgets/show_bottomsheet.dart';

class RoomMapScreen extends StatefulWidget {
  final Building building;
  final ReservationTimeRange reservationTimeRange;
  final bool isMapPositioning;
  final int resourceId;
  final int reservationId;
  const RoomMapScreen({
    super.key,
    required this.building,
    required this.reservationTimeRange,
    this.isMapPositioning = false,
    this.resourceId = 0,
    this.reservationId = 0,
  });

  @override
  State<RoomMapScreen> createState() => _RoomMapScreenState();
}

class _RoomMapScreenState extends State<RoomMapScreen> {
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
        create: (context) => ResourceRepository(),
        child: BlocProvider(
          create: (context) => RoomMapBloc(
              resourceRepository:
                  RepositoryProvider.of<ResourceRepository>(context),
              reservationTimeRange: widget.reservationTimeRange,
              isMapPositioning: widget.isMapPositioning,
              resourceId: widget.resourceId),
          child: Scaffold(
            body: BlocConsumer<RoomMapBloc, RoomMapState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is RoomMapInitial) {
                  BlocProvider.of<RoomMapBloc>(context).add(OnRoomMapInitial());
                  return const SizedBox();
                } else if (state is RoomMapLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  List<ResourceModel> resourceList =
                      state is RoomMapLoaded ? state.resourceDataList : [];
                  List<ResourceModel> resources = resourceList
                      .where(
                        (ResourceModel resourceItem) =>
                            widget.isMapPositioning && widget.resourceId != 0
                                ? resourceItem.buildingId ==
                                        widget.building.buildingId &&
                                    resourceItem.resourceId == widget.resourceId
                                : resourceItem.buildingId ==
                                    widget.building.buildingId,
                      )
                      .toList();
                  String errorResource = state is Error ? state.error : "";
                  return widget.building.imageLink.isEmpty
                      ? const RoomMapError(errorTitle: "Non Trova la Map")
                      : (resources.isEmpty
                          ? const RoomMapError(errorTitle: "Non ci sono Room")
                          : RoomMapLayout(
                              state: state,
                              resources: resources,
                              errorResource: errorResource,
                              building: widget.building,
                              reservationTimeRange: widget.reservationTimeRange,
                              isMapPositioning: widget.isMapPositioning,
                              reservationId: widget.reservationId));
                }
              },
            ),
          ),
        ));
  }
}

class RoomMapLayout extends StatefulWidget {
  const RoomMapLayout(
      {super.key,
      required this.state,
      required this.errorResource,
      required this.resources,
      required this.building,
      required this.reservationTimeRange,
      required this.isMapPositioning,
      required this.reservationId});

  final RoomMapState state;
  final String errorResource;
  final Building building;
  final ReservationTimeRange reservationTimeRange;
  final bool isMapPositioning;
  final int reservationId;
  final List<ResourceModel> resources;
  @override
  State<RoomMapLayout> createState() => _RoomMapLayoutState();
}

class _RoomMapLayoutState extends State<RoomMapLayout> {
  final roomButtonsFree = [
    'assets/icons/reservation/single_pc_free.png',
    'assets/icons/reservation/phone_boot_free.png',
    'assets/icons/reservation/meeting_room_free.png',
  ];
  final roomButtonsOccupied = [
    'assets/icons/reservation/single_pc_occupied.png',
    'assets/icons/reservation/phone_boot_occupied.png',
    'assets/icons/reservation/meeting_room_occupied.png',
  ];

  final transController = TransformationController();
  late TapDownDetails doubleTapDetails;

  bool isBottomSheetCompleted = false;

  void updateBottomSheetStatus(bool status) {
    setState(() {
      isBottomSheetCompleted = status;
    });
  }

  bool isBottomSheetRequest = false;

  void updateBottomSheetRequestStatus(bool status) {
    setState(() {
      isBottomSheetRequest = status;
    });
  }

  bool isCreaOrdDeleteBottomSheet = false;

  void updateCreaOrdDeleteBottomSheetStatus(bool status) {
    setState(() {
      isCreaOrdDeleteBottomSheet = status;
    });
  }

  handleDoubleTapDown(TapDownDetails details) {
    doubleTapDetails = details;
  }

  handleDoubleTap() {
    if (transController.value != Matrix4.identity()) {
      transController.value = Matrix4.identity();
    } else {
      final position = doubleTapDetails.localPosition;
      transController.value = Matrix4.identity()
        ..translate(-position.dx, -position.dy)
        ..scale(2.0);
    }
  }
  

  Future<void> _showModalSheet(
      ResourceModel resource, bool isMapPositioning) async {
    await showModalBottomSheet(
      context: context,
      builder: (builder) {
        return BottomSheetReservationWidget(
          resource: resource,
          reservationTimeRange: widget.reservationTimeRange,
          roomMapBloc: BlocProvider.of<RoomMapBloc>(context),
          stateBottomSheet: isMapPositioning,
          reservationId: widget.reservationId,
          updateBottomSheetStatus: updateBottomSheetStatus,
          updateBottomSheetRequestStatus: updateBottomSheetRequestStatus,
          updateCreaOrdDeleteBottomSheetStatus:
              updateCreaOrdDeleteBottomSheetStatus,
        );
      },
    );

    if (isBottomSheetCompleted) {
      showModalBottomSheet(
        context: context,
        enableDrag: false,
        builder: (builder) {
          return BottomSheetCongratulationAndDeletedSuccessfullyOrErrorWidget(
            roomMapBloc: BlocProvider.of<RoomMapBloc>(context),
            stateBottomSheet: isBottomSheetRequest,
            isCreaOrdDeleteBottomSheet: isCreaOrdDeleteBottomSheet,
            isBottomSheetRequest: isBottomSheetRequest,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const totalCells = 10 * 10; // Supponendo che la griglia sia 10x10
    const cells = 10;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Room Map'),
        ),
        body: Stack(
          textDirection: TextDirection.rtl,
          children: [
            Card(
              elevation: 5.0,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 130,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Container(),
                    ),
                    ListTile(
                      leading: SizedBox(
                        width: 30,
                        height: 30,
                        child: Image.asset(roomButtonsFree[0]),
                      ),
                      title: const Text('pc',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                      dense: true,
                      visualDensity: const VisualDensity(vertical: -3),
                    ),
                    ListTile(
                      leading: SizedBox(
                        width: 30,
                        height: 30,
                        child: Image.asset(roomButtonsFree[1]),
                      ),
                      title: const Text('phone booth',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                      dense: true,
                      visualDensity: const VisualDensity(vertical: -3),
                    ),
                    ListTile(
                      leading: SizedBox(
                        width: 30,
                        height: 30,
                        child: Image.asset(roomButtonsFree[2]),
                      ),
                      title: const Text('meeting room',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                      dense: true,
                      visualDensity: const VisualDensity(vertical: -3), // 缩小高度
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onDoubleTapDown: handleDoubleTapDown,
              onDoubleTap: handleDoubleTap,
              child: InteractiveViewer(
                transformationController: transController,
                maxScale: 20.0,
                child: Center(
                  child: Container(
                    width: 360,
                    height: 360,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.building.mapLink),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                        IgnorePointer(
                          child: GridView.count(
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: cells,
                            children: List.generate(totalCells, (index) {
                              final x = index % cells;
                              final y = index ~/ cells;
                              // Controlla se c'è un pulsante in questa posizione
                              final button = widget.resources.firstWhereOrNull(
                                  (room) => room.posX == x && room.posY == y);
                              if (button != null) {
                                return Container();
                              } else {
                                return Container(
                                  margin: const EdgeInsets.all(2),
                                  // color: Colors.white, // per test all griglia
                                );
                              }
                            }),
                          ),
                        ),
                        GridView.count(
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: cells,
                          children: List.generate(totalCells, (index) {
                            final x = index % cells;
                            final y = index ~/ cells;
                            // Controlla se c'è un pulsante in questa posizione
                            final value = widget.resources.firstWhereOrNull(
                                (room) => room.posX == x && room.posY == y);
                            if (value != null) {
                              return value.isDeleted
                                  ? Container()
                                  // : IconButton(
                                  //     icon: Image.asset(value.isFree
                                  //         ? roomButtonsFree[value.resourceType]
                                  //         : (widget.isMapPositioning
                                  //             ? "assets/icons/reservation/vector.png"
                                  //             : roomButtonsOccupied[
                                  //                 value.resourceType])),
                                  //     iconSize: 80,
                                  //     tooltip: value.name,
                                  //     onPressed: value.isFree
                                  //         ? () {
                                  //             _showModalSheet(value, false);
                                  //           }
                                  //         : (widget.isMapPositioning
                                  //             ? () {
                                  //                 _showModalSheet(value, true);
                                  //               }
                                  //             : null),
                                  //   );
                                  : GestureDetector(
                                      onTap: value.isFree
                                          ? () {
                                              _showModalSheet(value, false);
                                            }
                                          : (widget.isMapPositioning
                                              ? () {
                                                  _showModalSheet(value, true);
                                                }
                                              : null),
                                      child: Image.asset(
                                        value.isFree
                                            ? roomButtonsFree[
                                                value.resourceType]
                                            : (widget.isMapPositioning
                                                ? "assets/icons/reservation/vector.png"
                                                : roomButtonsOccupied[
                                                    value.resourceType]),
                                        width: 80,
                                        height: 80,
                                      ),
                                    );
                            } else {
                              return Container();
                            }
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
