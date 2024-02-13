import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pw5/ui/pages/layout/layout_screen.dart';

class RoomMapError extends StatelessWidget {
  final String errorTitle;
  const RoomMapError({
    super.key,
    required this.errorTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Room Map'),
        ),
        body: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            SvgPicture.asset(
              'assets/icons/nodata.svg',
              width: 210,
              height: 210,
            ),
            const SizedBox(height: 30),
            Text(
              errorTitle,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18.0,
                color: Color.fromARGB(255, 4, 4, 4),
              ),
            ),
            SizedBox(
              width: 130,
              height: 30,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LayoutScreen()),
                      (route) => false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                ),
                label: const Text(
                  'Book Now',
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 12.0,
                    color: Colors.white,
                  ),
                ),
                icon: const Icon(
                  Icons.map,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        )));
  }
}
