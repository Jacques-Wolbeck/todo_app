import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/android/widgets/custom/custom_app_bar.dart';
import 'package:todo_app/android/widgets/custom/custom_text_theme.dart';
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
        title: 'ToDo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.lightGreen,
            //brightness: Brightness.dark,
          ),
          textTheme: customTextTheme(),
          appBarTheme: customAppBar(),
        ),
        initialRoute: '/home',
        onGenerateRoute: (route) => onGenerateRoute(route),
      ),
    );
  }
}
