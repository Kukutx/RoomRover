import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pw5/data/repositories/auth_repository.dart';
import 'package:pw5/data/repositories/bookings_repository.dart';
import 'package:pw5/domain/models/booking_model.dart';
import 'package:pw5/domain/models/link_immagine_model.dart';
import 'package:pw5/domain/models/user_model.dart';
import 'package:pw5/ui/pages/layout/layout_screen.dart';
import 'package:pw5/ui/pages/profile/profile_bloc/profile_bloc.dart';
import 'package:pw5/ui/widgets/error_loading_bookings.dart';
import 'package:pw5/ui/widgets/no_reservation.dart';
import 'package:pw5/ui/widgets/profile_section.dart';
import 'package:pw5/ui/widgets/show_bookings.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(create: (_) => AuthRepository()),
        RepositoryProvider<BookingsRepository>(
            create: (_) =>
                BookingsRepository()), // Aggiungi il provider per BookingsRepository
      ],
      child: BlocProvider(
        create: (context) => ProfileBloc(
          authRepository: RepositoryProvider.of<AuthRepository>(context),
          bookingsRepository:
              RepositoryProvider.of<BookingsRepository>(context),
        ),
        child: Scaffold(
          body: BlocConsumer<ProfileBloc, ProfileState>(
            listener: (context, state) => {
              if (state is ViewAllButtonClicked)
                {
                  Navigator.pushNamed(context, "/allYourReservations"),
                  BlocProvider.of<ProfileBloc>(context).add(OnInitial())
                }
              else if (state is BookNowClicked)
                {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LayoutScreen()),
                      (route) => false)
                  //qui si va alla sezione edifici
                }
            },
            builder: (context, state) {
              if (state is Initial) {
                BlocProvider.of<ProfileBloc>(context).add(OnInitial());
                return const SizedBox();
              } else if (state is Loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is Loaded) {
                return ProfileLayout(
                  state: state,
                  profilo: state.profile,
                  immagine: state.immagine,
                  fourBookings: state.fourBookings,
                  errorProfile: state.errorProfile,
                  errorBookings: state.errorBooking,
                  erroreImmagine: state.erroreImmagine,
                );
              } else {
                return const Placeholder();
              }
            },
          ),
        ),
      ),
    );
  }
}

class ProfileLayout extends StatefulWidget {
  const ProfileLayout(
      {super.key,
      required this.state,
      required this.errorProfile,
      required this.errorBookings,
      required this.erroreImmagine,
      required this.profilo,
      required this.immagine,
      required this.fourBookings});

  final ProfileState state;
  final String errorProfile;
  final String errorBookings;
  final String erroreImmagine;
  final User profilo;
  final Uint8List immagine;
  final List<Booking> fourBookings;

  @override
  State<ProfileLayout> createState() => _ProfileLayoutState();
}

class _ProfileLayoutState extends State<ProfileLayout> {
  @override
  Widget build(BuildContext context) {
    ProfileBloc bloc = BlocProvider.of<ProfileBloc>(context);

    return RefreshIndicator(
      onRefresh: () => Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          bloc.add(OnInitial());
        });
      }),
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                //titolo nome utente
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: widget.errorProfile == "",
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 15, top: 15, bottom: 15),
                      child: Text(
                        widget.profilo.displayName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 21.0,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.errorProfile != "",
                    child: const Padding(
                      padding: EdgeInsets.only(left: 15, top: 15, bottom: 15),
                      child: Text(
                        "Unknown",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 21.0,
                          color: Color.fromARGB(255, 3, 3, 3),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                //sezione profilo
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  WidgetProfilo(
                    errorProfile: widget.errorProfile,
                    profilo: widget.profilo,
                    immagine: widget.immagine,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 41),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Your Reservations",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18.0,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      SizedBox(
                        width: 110,
                        height: 30,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            bloc.add(ViewAllButtonClickedEvent());
                            // Azione da eseguire quando il pulsante viene premuto
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue, // Colore di sfondo
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20.0), // Bordo arrotondato
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0), // Spaziatura orizzontale
                          ),
                          label: const Text(
                            'View All', // Testo del pulsante
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
                    ]),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                //sezione bookings
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    //caricato bookings con successo e ho le four bookings
                    visible: widget.errorBookings == "" &&
                        widget.fourBookings.isNotEmpty,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //qui mostro le tue four bookings
                          ShowBookings(bookings: widget.fourBookings),
                        ]),
                  ),
                  Visibility(
                    //caricato bookings con successo ma non ho le four bookings
                    visible: widget.errorBookings == "" &&
                        widget.fourBookings.isEmpty,
                    child: const NoReservations(),
                  ),
                  Visibility(
                    //errore caricamento bookings
                    visible: widget.errorBookings != "",
                    child: ErrorLoadingBookings(widget: widget),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
