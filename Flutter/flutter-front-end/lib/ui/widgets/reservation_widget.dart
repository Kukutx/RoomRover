// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pw5/data/repositories/resource_repository.dart';
import 'package:pw5/domain/models/booking_model.dart';
import 'package:pw5/domain/models/building_model.dart';
import 'package:pw5/domain/models/reservation_time_range_model.dart';
import 'package:pw5/ui/pages/layout/layout_screen.dart';
import 'package:pw5/ui/pages/roommap/roommap_screen.dart';

class ReservationWidget extends StatefulWidget {
  const ReservationWidget({super.key, required this.reservation});
  final Booking reservation;

  @override
  State<ReservationWidget> createState() => _ReservationWidgetState();
}

class _ReservationWidgetState extends State<ReservationWidget> {
  final ResourceRepository resourceRepository = ResourceRepository();
  late Building building;
  bool isClicked = false;

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

  Future<void> getByReservationId(int reservationId) async {
    try {
      await resourceRepository
          .getByReservationId(reservationId)
          .then((building) {
        this.building = building;
      });
    } catch (e) {
      debugPrint('Your reservation failed: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(_createSnackbar('Your reservation failed'));
    }
  }

  @override
  void initState() {
    getByReservationId(widget.reservation.reservationId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!isClicked) {
          isClicked = true;
          var reservationTimeRange = ReservationTimeRange(
            buildingId: building.buildingId,
            startDateTime: widget.reservation.startDateTime,
            endDateTime: widget.reservation.endDateTime,
          );

          if (widget.reservation.isDeleted == false) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RoomMapScreen(
                      building: building,
                      reservationTimeRange: reservationTimeRange,
                      resourceId: widget.reservation.resourceId,
                      reservationId: widget.reservation.reservationId,
                      isMapPositioning: true)),
            ).then((_) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LayoutScreen()),
                  (route) => false);
            });
          }
        }
      },
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Container(
            width: 360,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: widget.reservation.isDeleted == true
                      ? Colors.red
                      : Colors.grey,
                  offset: const Offset(0, 4),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 110,
                      height: 100,
                      margin: const EdgeInsets.only(bottom: 30),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          image: AssetImage(
                              _getImagePath(widget.reservation.resourceName)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 28),
                    SizedBox(
                      width: 150,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                "location name",
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              Text(
                                widget.reservation.resourceName,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                "schedule",
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              Text(
                                "${_formatTime(widget.reservation.startDateTime)} to ${_formatTime(widget.reservation.endDateTime)}",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                "booked day",
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              Text(
                                "${widget.reservation.startDateTime.day} ${_getMonthName(widget.reservation.startDateTime.month)} ${widget.reservation.startDateTime.year}",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 7,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 280,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: buildUserListRow(
                            context, widget.reservation.usersId),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    if (_isScrollViewScrollable(
                        widget.reservation.usersId, context))
                      const Icon(Icons.arrow_forward),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(dateTime.hour)}:${twoDigits(dateTime.minute)}";
  }

  String _getImagePath(String resourceName) {
    switch (resourceName) {
      case "Seat":
        return "assets/icons/pc.png";
      case "PhoneBoot":
        return "assets/icons/phone_boot.png";
      case "Room":
        return "assets/icons/omino_meeting.png";
      default:
        return "assets/icons/nondisponibile.png";
    }
  }

  String _getMonthName(int month) {
    const List<String> monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return monthNames[month - 1];
  }

  bool _isScrollViewScrollable(List<String> users, BuildContext context) {
    double totalWidth = users.length * (80 + 10);
    return totalWidth > MediaQuery.of(context).size.width;
  }

  Widget buildUserListRow(BuildContext context, List<String> users) {
    return Row(
      children: [
        for (String user in users)
          Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              user,
              style: const TextStyle(color: Colors.white),
            ),
          ),
      ],
    );
  }
}
