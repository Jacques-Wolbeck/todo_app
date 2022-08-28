import 'package:flutter/material.dart';
import 'package:todo_app/android/screens/add_screen.dart';
import 'package:todo_app/android/widgets/custom/custom_page_route.dart';

import 'screens/home_screen.dart';

Route onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/add':
      return CustomPageRoute(child: AddScreen(), settings: settings);
    case '/home':
    default:
      return CustomPageRoute(child: const HomeScreen(), settings: settings);
  }
}
