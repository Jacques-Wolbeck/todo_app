import 'package:flutter/material.dart';
import 'views/home_view.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.grey,
        primaryColor: Colors.deepPurple,
        primaryColorLight: Colors.white,
        splashColor: Colors.deepPurple,
      ),
      home: const HomeView(),
    );
  }
}
