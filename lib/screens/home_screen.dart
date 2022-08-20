import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/blocs/todos_bloc.dart';
import 'package:todo_app/blocs/todos_state.dart';
import 'package:todo_app/screens/add_screen.dart';

import '../blocs/todos_event.dart';
import '../models/todo_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo'),
      ),
      body: _body(),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Theme.of(context).primaryColor,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) => AddScreen()),
            ),
          );
        },
        backgroundColor: Theme.of(context).primaryColorLight,
      ),
    );
  }

  _body() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<TodosBloc, TodosState>(
        builder: (context, state) {
          if (state is TodosLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is TodosError) {
            return Center(
              child: Text(
                "Unable to load data",
                style: TextStyle(
                  color: Theme.of(context).primaryColorLight,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
          if (state is TodosLoaded) {
            final todoList = state.todos;
            debugPrint(todoList.length.toString());
            if (todoList.isEmpty) {
              return const Center(
                child: Text("No data"),
              );
            }
            debugPrint("-------- ${todoList.length}");
            return ListView.separated(
              itemCount: todoList.length,
              itemBuilder: (context, index) {
                return _cardTile(todoList[index]);
              },
              separatorBuilder: (context, __) => const Divider(),
            );
          } else {
            return const Text('Something went wrong');
          }
        },
      ),
    );
  }

  Card _cardTile(TodoModel todo) {
    return Card(
      //elevation: 5.0,
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(10.0),
        color: Theme.of(context).primaryColor,
        child: InkWell(
          onLongPress: () {
            context.read<TodosBloc>().add(DeleteTodo(todo: todo));
          },
          child: ListTile(
            title: Text((todo.title == null) ? 'No title' : todo.title!),
            subtitle: Text(todo.uid.toString()),
          ),
        ),
      ),
    );
  }
}
