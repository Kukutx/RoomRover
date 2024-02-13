import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pw5/data/repositories/auth_repository.dart';
import 'package:pw5/ui/pages/home/home_screen.dart';
import 'package:pw5/ui/pages/profile/profile_screen.dart';

import 'layout_bloc/layout_bloc.dart';

class LayoutScreen extends StatefulWidget {
  final int currentPageIndex;
  const LayoutScreen({super.key, this.currentPageIndex = 0});

  @override
  State<LayoutScreen> createState() => _LayoutState();
}

class _LayoutState extends State<LayoutScreen> {
  late LayoutBloc _layoutBloc;

  @override
  void initState() {
    super.initState();
    _layoutBloc = LayoutBloc(authRepository: AuthRepository());
    _layoutBloc.add(OnInitial());
  }

  @override
  void dispose() {
    _layoutBloc.close();
    super.dispose();
  }

  late int currentPageIndex = widget.currentPageIndex;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LayoutBloc, LayoutState>(
      bloc: _layoutBloc,
      builder: (context, state) {
        Widget profileIcon;
        if (state is LayoutLoaded) {
          profileIcon = CircleAvatar(
            backgroundImage: MemoryImage(state.pic),
          );
        } else {
          profileIcon = const CircleAvatar(
            backgroundImage: AssetImage('assets/icons/default_profile.png'),
          );
        }

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: const Text(
              "RoomRover",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 6.0),
                child: Ink(
                  decoration: const ShapeDecoration(
                    color: Colors.white,
                    shape: CircleBorder(),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () {
                      // Funzione da eseguire al click dell'icona di logout
                      logout(context);
                    },
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            color: Colors.white,
            surfaceTintColor: Colors.white,
            shape: const CircularNotchedRectangle(),
            padding: const EdgeInsets.all(0),
            height:61,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Ink(
                      decoration: const ShapeDecoration(
                        color: Colors.white,
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.map_outlined),
                        onPressed: () {
                          setState(() {
                            currentPageIndex = 0;
                          });
                        },
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 1,
                      color: Colors.black,
                    ),
                    IconButton(
                      icon: Badge(child: profileIcon),
                      onPressed: () {
                        setState(() {
                          currentPageIndex = 1;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          body: IndexedStack(
            index: currentPageIndex,
            children: const [
              HomeScreen(),
              ProfileScreen(),
            ],
          ),
        );
      },
    );
  }

  void logout(BuildContext context) {
    if(_layoutBloc.state is! LogoutClicked){
      AuthRepository authRepository = AuthRepository();
      _layoutBloc.add(LogoutClicked());
      authRepository.azureLogout(context);
    }
  }
}
