import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pw5/ui/pages/layout/layout_screen.dart';

class NoReservations extends StatelessWidget {
  const NoReservations({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
        const Text(
          "no data",
          style: TextStyle(
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
              //qui deve navigare alla sezione edifici
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LayoutScreen()), (route) => false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, // Colore di sfondo
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0), // Bordo arrotondato
              ),
              padding: const EdgeInsets.symmetric(
                  horizontal: 10.0), // Spaziatura orizzontale
            ),
            label: const Text(
              'Book Now', // Testo del pulsante
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize:
                    12.0, // Riduci la dimensione del font a tuo piacimento
                color: Colors.white, // Imposta il testo su bianco
              ),
            ),
            icon: const Icon(
              Icons.arrow_forward, // Icona freccia destra
              color: Colors.white, // Colore dell'icona
            ),
          ),
        ),
      ],
    );
  }
}
