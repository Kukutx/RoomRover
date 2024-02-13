import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pw5/data/repositories/buildings_repository.dart';
import 'package:pw5/domain/models/building_model.dart';
import 'package:pw5/ui/pages/home/home_bloc/home_bloc.dart';
import 'package:pw5/ui/pages/layout/layout_screen.dart';
import 'package:pw5/ui/pages/reservationtime/reservation_time.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
        create: (context) => BuildingsRepository(),
        child: BlocProvider(
          create: (context) => HomeBloc(
            buildingsRepository:
                RepositoryProvider.of<BuildingsRepository>(context),
          ),
          child: Scaffold(
            body: BlocConsumer<HomeBloc, HomeState>(
              listener: (context, state) {
                if (state is ImageClicked) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ReservationTimeScreen(building: state.building)),
                  ).then((_) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LayoutScreen()),
                        (route) => false);
                  });
                }
              },
              builder: (context, state) {
                if (state is HomeInitial) {
                  BlocProvider.of<HomeBloc>(context).add(OnHomeInitial());
                  return const SizedBox();
                } else if (state is HomeLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  List<Building> buildings =
                      state is HomeLoaded ? state.buildingsDataList : [];
                  String errorBuildings = state is Error ? state.error : "";
                  return HomeLayout(
                      state: state,
                      buildings: buildings,
                      errorBuildings: errorBuildings);
                }
              },
            ),
          ),
        ));
  }
}

class HomeLayout extends StatefulWidget {
  const HomeLayout(
      {super.key,
      required this.state,
      required this.errorBuildings,
      required this.buildings});

  final HomeState state;
  final String errorBuildings;
  final List<Building> buildings;

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  @override
  Widget build(BuildContext context) {
    final List<Building> buildings = widget.buildings;
    HomeBloc homeBloc = BlocProvider.of<HomeBloc>(context);
    return RefreshIndicator(
      onRefresh: () => Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          homeBloc.add(OnHomeInitial());
        });
      }),
      child: Row(
        children: [
          Expanded(
            child: ListView(
              children: List.generate(buildings.length, (index) {
                return RoomWidget(
                    state: widget.state, building: buildings[index]);
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class RoomWidget extends StatelessWidget {
  final HomeState state;
  final Building building;
  const RoomWidget({super.key, required this.state, required this.building});

  @override
  Widget build(BuildContext context) {
    HomeBloc homeBloc = BlocProvider.of<HomeBloc>(context);
    ImageProvider imageProvider =
        state is ImageError || building.imageLink.isEmpty
            ? const AssetImage('assets/images/booking_failed.png')
            : NetworkImage(building.imageLink) as ImageProvider;
    return Container(
        padding: const EdgeInsets.symmetric(horizontal:28, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              margin: EdgeInsets.zero,
              clipBehavior: Clip.hardEdge,
              elevation: 5,
              child: InkWell(
                onTap: () {
                  homeBloc.add(OnImageClicked(building));
                },
                child: Container(
                  height: 220,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: imageProvider,
                    ),
                  ),
                ),
              ),
            ),
            Container(
                width: 120,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 5,
                      ),
                    ],
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(12),
                        bottomLeft: Radius.circular(12))),
                child: Text(
                  building.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                )),
          ],
        ));
  }
}
