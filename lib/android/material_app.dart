import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/android/routes.dart';

import '../shared/blocs/todos_bloc.dart';
import '../shared/blocs/todos_event.dart';
import '../shared/database/database_controller.dart';

class AndroidApp extends StatelessWidget {
  const AndroidApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TodosBloc(dbInstance: DatabaseController.db)..add(const LoadTodos()),
      child: MaterialApp(
        title: 'Todo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.grey,
          primaryColor: Colors.deepPurple,
          primaryColorLight: Colors.white,
          splashColor: Colors.deepPurple,
        ),
        initialRoute: '/home',
        routes: appRoutes,
      ),
    );
  }
}
