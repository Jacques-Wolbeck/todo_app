import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/blocs/todos_event.dart';
import 'package:todo_app/database/database_controller.dart';
import 'blocs/todos_bloc.dart';
import 'screens/home_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => DatabaseController.db.database,
      child: BlocProvider(
        create: (context) => TodosBloc(dbInstance: DatabaseController.db)
          ..add(const LoadTodos()),
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
          home: const HomeView(),
        ),
      ),
    );
  }
}
