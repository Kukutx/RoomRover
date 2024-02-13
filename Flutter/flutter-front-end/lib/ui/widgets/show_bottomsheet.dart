// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:pw5/data/repositories/auth_repository.dart';
import 'package:pw5/data/repositories/resource_repository.dart';
import 'package:pw5/domain/models/new_reservation_model.dart';
import 'package:pw5/domain/models/reservation_time_range_model.dart';
import 'package:pw5/domain/models/resource_model.dart';
import 'package:pw5/domain/models/user_model.dart';
import 'package:pw5/ui/pages/layout/layout_screen.dart';
import 'package:pw5/ui/pages/roommap/map_bloc/roommap_bloc.dart';

class BottomSheetReservationWidget extends StatefulWidget {
  final ResourceModel resource;
  final ReservationTimeRange reservationTimeRange;
  final RoomMapBloc roomMapBloc;
  final bool stateBottomSheet;
  final int reservationId;

  final Function updateBottomSheetStatus;
  final Function updateBottomSheetRequestStatus;
  final Function updateCreaOrdDeleteBottomSheetStatus;

  const BottomSheetReservationWidget(
      {super.key,
      required this.resource,
      required this.reservationTimeRange,
      required this.roomMapBloc,
      this.stateBottomSheet = false,
      this.reservationId = 0,
      required this.updateBottomSheetStatus,
      required this.updateBottomSheetRequestStatus,
      required this.updateCreaOrdDeleteBottomSheetStatus});

  @override
  State<BottomSheetReservationWidget> createState() =>
      _BottomSheetReservationWidgetState();
}

class _BottomSheetReservationWidgetState
    extends State<BottomSheetReservationWidget> {
  final ResourceRepository resourceRepository = ResourceRepository();
  final MultiSelectController _controller = MultiSelectController();
  AuthRepository auth = AuthRepository();
  List<ValueItem> options = [];
  List<int> usersIds = [];
  bool isLoading = false;

  SnackBar _createSnackbar(String msg) {
    return SnackBar(
      elevation: 5.0,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35.0)),
      content: Wrap(
        children: [
          Center(
            child: Text(msg),
          ),
        ],
      ),
    );
  }

  Future<List<ValueItem>> _multiSelectDropDownUserData() async {
    try {
      List<UserGetAll> emails = await auth.getAllUsers();
      return emails
          .map((user) => ValueItem(label: user.email, value: user.userId))
          .toList();
    } catch (e) {
      debugPrint('Request failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          _createSnackbar('MultiSelect DropDown get UserData Request failed'));
      return [];
    }
  }

  Future<void> creaReservation(NewReservation newReservation) async {
    try {
      setState(() {
        isLoading = true;
      });
      await resourceRepository.createMyReservation(newReservation);
      await widget.updateBottomSheetRequestStatus(true);
    } catch (e) {
      await widget.updateBottomSheetRequestStatus(false);
      debugPrint('Your reservation failed: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(_createSnackbar('Your reservation failed'));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteReservation(int reservationId) async {
    try {
      setState(() {
        isLoading = true;
      });
      await resourceRepository.deleteMyReservation(reservationId);
      await widget.updateBottomSheetRequestStatus(true);
    } catch (e) {
      await widget.updateBottomSheetRequestStatus(false);
      debugPrint('Your delete reservation failed: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(_createSnackbar('Your delete reservation failed'));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime startDateTime = widget.reservationTimeRange.startDateTime;
    DateTime endDateTime = widget.reservationTimeRange.endDateTime;

    String date =
        "${startDateTime.year}-${startDateTime.month}-${startDateTime.day}";
    String startTime =
        "${startDateTime.hour.toString().padLeft(2, '0')}:${startDateTime.minute.toString().padLeft(2, '0')}";
    String endTime =
        "${endDateTime.hour.toString().padLeft(2, '0')}:${endDateTime.minute.toString().padLeft(2, '0')}";
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0))),
      padding: const EdgeInsets.all(10.0),
      child: Wrap(
        children: <Widget>[
          ListTile(
              trailing: IconButton(
                  color: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  icon: const Icon(Icons.cancel, size: 48.0),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              title: Text(widget.resource.name),
              subtitle: Text(widget.resource.description!),
              onTap: () {}),
          const Divider(),
          Row(
            children: <Widget>[
              Expanded(
                child: ListTile(
                  leading: const Icon(Icons.date_range),
                  title: const Text('Date'),
                  subtitle: Text(
                    date,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListTile(
                  leading: const Icon(Icons.access_time),
                  title: const Text('Time'),
                  subtitle: Text(
                    "$startTime - $endTime",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          widget.resource.resourceType == 2 && !widget.stateBottomSheet
              ? ListTile(
                  title: FutureBuilder<List<ValueItem>>(
                  future: _multiSelectDropDownUserData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // While waiting for the data, show a loading indicator
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      // If an error occurred, display an error message
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return MultiSelectDropDown(
                        showClearIcon: true,
                        controller: _controller,
                        onOptionSelected: (options) {
                          usersIds = options
                              .map((option) => option.value)
                              .cast<int>()
                              .toList();
                        },
                        maxItems: 5,
                        options: snapshot.data!,
                        selectionType: SelectionType.multi,
                        chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                        dropdownHeight: 300,
                        searchEnabled: true,
                        optionTextStyle: const TextStyle(fontSize: 16),
                        selectedOptionIcon: const Icon(Icons.check_circle),
                      );
                    }
                  },
                ))
              : const SizedBox(),
          const SizedBox(height: 10),
          ListTile(
            title: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide.none,
                foregroundColor: Colors.white,
                backgroundColor: (widget.stateBottomSheet == true
                    ? Colors.red
                    : Colors.blue),
                shadowColor: Colors.black,
                elevation: 5,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(18),
                  ),
                ),
              ),
              onPressed: isLoading
                  ? null
                  : () async {
                      if (!widget.stateBottomSheet) {
                        var newReservation = NewReservation(
                          reservationId: 0,
                          startDateTime:
                              widget.reservationTimeRange.startDateTime,
                          endDateTime: widget.reservationTimeRange.endDateTime,
                          resourceId: widget.resource.resourceId,
                          isDeleted: true,
                          usersId: usersIds,
                        );
                        await creaReservation(newReservation);
                        await Future.delayed(const Duration(seconds: 1));
                        widget.roomMapBloc.add(OnRoomMapInitial());
                        Navigator.pop(context);
                        widget.updateBottomSheetStatus(true);
                        widget.updateCreaOrdDeleteBottomSheetStatus(true);
                      } else {
                        await deleteReservation(widget.reservationId);
                        await Future.delayed(const Duration(seconds: 1));
                        Navigator.pop(context);
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const LayoutScreen(currentPageIndex: 1)),
                            (route) => false);
                        widget.updateBottomSheetStatus(true);
                        widget.updateCreaOrdDeleteBottomSheetStatus(false);
                      }
                    },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (widget.stateBottomSheet == true
                      ? const Icon(Icons.delete_forever)
                      : const Icon(Icons.book)),
                  isLoading
                      ? const Text('Loading...')
                      : ((widget.stateBottomSheet == true
                          ? const Text("Delete")
                          : const Text("Book now !")))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomSheetCongratulationAndDeletedSuccessfullyOrErrorWidget
    extends StatefulWidget {
  final RoomMapBloc roomMapBloc;
  final bool stateBottomSheet;
  final bool isCreaOrdDeleteBottomSheet;
  final bool isBottomSheetRequest;
  const BottomSheetCongratulationAndDeletedSuccessfullyOrErrorWidget(
      {super.key,
      required this.roomMapBloc,
      this.stateBottomSheet = false,
      this.isCreaOrdDeleteBottomSheet = false,
      required this.isBottomSheetRequest});

  @override
  State<BottomSheetCongratulationAndDeletedSuccessfullyOrErrorWidget>
      createState() =>
          BottomSheetCongratulationAndDeletedSuccessfullyOrErrorWidgetState();
}

class BottomSheetCongratulationAndDeletedSuccessfullyOrErrorWidgetState
    extends State<
        BottomSheetCongratulationAndDeletedSuccessfullyOrErrorWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0))),
      padding: const EdgeInsets.all(10.0),
      child: Wrap(
        children: <Widget>[
          ListTile(
              trailing: IconButton(
                  color: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  icon: const Icon(Icons.cancel, size: 48.0),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              title: Text(
                  (widget.stateBottomSheet
                      ? (widget.isCreaOrdDeleteBottomSheet
                          ? 'Congratulation'
                          : 'Deleted Successfully')
                      : "Error: booking failed"),
                  style: const TextStyle(
                    fontFamily: 'verdana_regular',
                    fontSize: 24,
                  )),
              onTap: () {}),
          const Divider(),
          const SizedBox(height: 10),
          Center(
              child: SizedBox(
            width: 290,
            height: 290,
            child: Image(
              image: (widget.stateBottomSheet == true
                  ? (widget.isCreaOrdDeleteBottomSheet
                      ? const AssetImage('assets/images/Configuration.png')
                      : const AssetImage(
                          'assets/images/deleted_successfully.png'))
                  : const AssetImage('assets/images/booking_failed.png')),
            ),
          )),
          const SizedBox(height: 10),
          (!widget.isCreaOrdDeleteBottomSheet /*||isError*/
              ? const SizedBox()
              : ListTile(
                  title: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide.none,
                      foregroundColor: Colors.white,
                      backgroundColor: (widget.stateBottomSheet == true
                          ? Colors.blue
                          : Colors.red),
                      shadowColor: Colors.black,
                      elevation: 5,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(18),
                        ),
                      ),
                    ),
                    onPressed: () {
                      // refresh page
                      widget.roomMapBloc.add(OnRoomMapInitial());
                      Navigator.pop(context);

                      if (widget.isCreaOrdDeleteBottomSheet) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const LayoutScreen(currentPageIndex: 1)),
                            (route) => false);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        (widget.isCreaOrdDeleteBottomSheet == true ||
                                !widget.isBottomSheetRequest
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.refresh)),
                        (widget.isCreaOrdDeleteBottomSheet == true
                            ? const Text("Go to Profile")
                            : const Text("Retry")),
                      ],
                    ),
                  ),
                )),
        ],
      ),
    );
  }
}
