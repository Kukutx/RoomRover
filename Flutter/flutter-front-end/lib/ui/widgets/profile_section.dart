import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pw5/domain/models/link_immagine_model.dart';
import 'package:pw5/domain/models/user_model.dart';

class WidgetProfilo extends StatefulWidget {
  const WidgetProfilo({
    super.key,
    required this.errorProfile,
    required this.profilo,
    required this.immagine,
  });

  final String errorProfile;
  final User profilo;
  final Uint8List immagine;

  @override
  State<WidgetProfilo> createState() => _WidgetProfiloState();
}

class _WidgetProfiloState extends State<WidgetProfilo> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300, // Personalizza la larghezza della card
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0, 4), // Offset per l'ombra
              blurRadius: 8, // Intensità dell'ombra
            ),
          ],
        ),
        child: Row(
          children: [
            // Immagine a sinistra
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: _fotoProfilo(widget.immagine),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16), // Spazio tra l'immagine e il testo
            // Testo a destra
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Office Location: ",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      _abbreviateText(widget.profilo.officeLocation, 17),
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8), // Spazio tra i due Text
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Job title: ",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      _abbreviateText(widget.profilo.jobTitle, 17),
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _abbreviateText(String text, int maxLength) {
    if (text.length > maxLength) {
      return "${text.substring(0, maxLength - 3)}...";
    } else {
      return text;
    }
  }
  
  _fotoProfilo(Uint8List immagine) {
    if(widget.immagine.isEmpty){
      return const NetworkImage("https://hips.hearstapps.com/hmg-prod/images/legacy-fre-image-placeholder-it-1-1674070998.png?crop=0.5xw:1xh;center,top&resize=640:*");
    }
    else{
      return  MemoryImage(widget.immagine);
    }
  }
}
