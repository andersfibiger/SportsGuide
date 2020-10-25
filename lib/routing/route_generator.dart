import 'package:SportsGuide/pages/home.dart';
import 'package:SportsGuide/pages/profile/profile.dart';
import 'package:SportsGuide/routing/routes.dart';
import 'package:flutter/material.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Routes.HOME:
      return MaterialPageRoute(builder: (_) => Home());
    case Routes.PROFILE:
      return MaterialPageRoute(builder: (_) => Profile());
    default:
      return null;
      break;
  }
}
