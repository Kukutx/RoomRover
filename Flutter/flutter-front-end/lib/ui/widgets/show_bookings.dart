import 'package:flutter/material.dart';
import 'package:pw5/domain/models/booking_model.dart';
import 'package:pw5/ui/widgets/reservation_widget.dart';

class ShowBookings extends StatelessWidget {
  const ShowBookings({Key? key, required this.bookings}) : super(key: key);
  final List<Booking> bookings;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var booking in bookings)
          Container(
            margin: const EdgeInsets.only(bottom: 6.0),
            child: ReservationWidget(reservation: booking),
          ),
      ],
    );
  }
}