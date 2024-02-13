import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pw5/data/repositories/bookings_repository.dart';
import 'package:pw5/domain/models/booking_model.dart';
import 'package:pw5/domain/models/filters_model.dart';
import 'package:pw5/ui/pages/allreservations/allreservations__bloc/allreservations_bloc.dart';
import 'package:pw5/ui/pages/layout/layout_screen.dart';
import 'package:pw5/ui/widgets/error_loading_bookings.dart';
import 'package:pw5/ui/widgets/filter_modal.dart';
import 'package:pw5/ui/widgets/no_reservation.dart';
import 'package:pw5/ui/widgets/show_bookings.dart';

class AllReservationsScreen extends StatefulWidget {
  const AllReservationsScreen({super.key, required this.filters});
  final Filters filters;
  @override
  State<AllReservationsScreen> createState() => _AllReservationsScreenState();
}

class _AllReservationsScreenState extends State<AllReservationsScreen> {
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => BookingsRepository(),
      child: BlocProvider(
        create: (context) => AllReservationsBloc(
          filters: widget.filters,
          bookingsRepository:
              RepositoryProvider.of<BookingsRepository>(context),
        ),
        child: Scaffold(
          body: BlocConsumer<AllReservationsBloc, AllReservationsState>(
            listener: (context, state) => {
              if (state is ReservationClicked)
                {
                  Navigator.pushNamed(context,
                      "/book") //qui si va alla mappa ma con selezionata la postazione/room
                }
              else if (state is BookNowClicked)
                {
                  Navigator.pushNamed(
                      context, "/book") //qui si va alla mappa in generale
                }
            },
            builder: (context, state) {
              if (state is Initial) {
                BlocProvider.of<AllReservationsBloc>(context).add(OnInitial());
                return const SizedBox();
              } else if (state is Loading) {
                return const Center(child: CircularProgressIndicator());
              } else {
                List<Booking> bookings =
                    state is Loaded ? state.yourBookings : [];
                String errorBookings = state is Error ? state.error : "";
                return AllReservationsLayout(
                    state: state,
                    bookings: bookings,
                    errorBookings: errorBookings);
              }
            },
          ),
        ),
      ),
    );
  }
}

class AllReservationsLayout extends StatefulWidget {
  const AllReservationsLayout(
      {super.key,
      required this.state,
      required this.errorBookings,
      required this.bookings});

  final AllReservationsState state;
  final String errorBookings;
  final List<Booking> bookings;

  @override
  State<AllReservationsLayout> createState() => _AllReservationsLayoutState();
}

class _AllReservationsLayoutState extends State<AllReservationsLayout> {

  @override
  Widget build(BuildContext context) {
    AllReservationsBloc bloc = BlocProvider.of<AllReservationsBloc>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.orange),
          onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LayoutScreen(currentPageIndex:1)),
              (route) => false),
        ),
        title: const Text(
          "Your Reservations",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Visibility(
            visible: widget.state is! Error || widget.bookings.isNotEmpty,
            child: IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {
                showFilterModal(context, bloc);
              },
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            bloc.add(OnInitial());
          });
        }),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: widget.state is Loaded && widget.bookings.isEmpty,
                      child: const Column(
                        children: [
                          SizedBox(
                            height: 100,
                          ),
                          NoReservations(),
                        ],
                      ),
                    ),
                    Visibility(
                      visible:
                          widget.state is Loaded && widget.bookings.isNotEmpty,
                      child: ShowBookings(bookings: widget.bookings),
                    ),
                    Visibility(
                      visible: widget.state is Error,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 100,
                          ),
                          ErrorLoadingBookings(widget: widget),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
