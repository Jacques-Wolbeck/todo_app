import 'package:flutter/material.dart';
import 'package:todo_app/android/screens/add_screen.dart';

import 'screens/home_screen.dart';

var appRoutes = <String, WidgetBuilder>{
  '/home': (context) => const HomeScreen(),
  '/add': (context) => AddScreen(),
};
