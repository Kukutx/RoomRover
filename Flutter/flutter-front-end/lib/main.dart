import 'package:flutter/material.dart';
import 'package:pw5/domain/helpers/oauth_config.dart';
import 'package:pw5/domain/models/filters_model.dart';
import 'package:pw5/ui/pages/allreservations/allreservations_screen.dart';
import 'package:pw5/ui/pages/home/home_screen.dart';
import 'package:pw5/ui/pages/layout/layout_screen.dart';
import 'package:pw5/ui/pages/login/login_screen.dart';
import 'package:pw5/ui/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RoomRover',
      navigatorKey: OauthConfig.navigatorKey,
      theme: AppTheme.theme,
      onGenerateRoute: (settings) {
        var routName = settings.name;

        var routes = {
          "/login": (context) => const LoginScreen(),
          "/layout": (context) => const LayoutScreen(),
          "/allYourReservations": (context) => AllReservationsScreen(filters: Filters(dateEnd: null,dateStart: null,email: null),),
          "/home": (context) => const HomeScreen(),
        };

        WidgetBuilder builder =
            routes[routName] ?? (context) => const LoginScreen();

        return MaterialPageRoute(builder: (context) => builder(context));
      },
    );
  }
}
