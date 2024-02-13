import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ErrorLoadingBookings extends StatelessWidget {
  const ErrorLoadingBookings({
    super.key,
    required this.widget,
  });

  final dynamic widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 30,),
        SvgPicture.asset(
                'assets/icons/failed.svg',
                width: 210,
                height: 210,
              ),
        const SizedBox(height: 30),
        const Text("Errore: Qualcosa è andato storto!", style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18.0,
                        color: Color.fromARGB(255, 244, 8, 8),
                      ),)
      ],
    );
  }
}