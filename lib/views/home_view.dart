import 'package:flutter/material.dart';
import 'package:todo_app/blocs/todo_bloc.dart';
import 'package:todo_app/blocs/todo_event.dart';
import 'package:todo_app/views/add_view.dart';

import '../models/todo_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final TodoBloc bloc;

  @override
  void initState() {
    bloc = TodoBloc();
    bloc.inputTodo.add(LoadTodoEvent());
    super.initState();
  }

  @override
  void dispose() {
    bloc.inputTodo.close();
    super.dispose();
  }

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
              builder: ((context) => AddView(bloc: bloc)),
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
      child: StreamBuilder<List<TodoModel>>(
        stream: bloc.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(
              "Não foi possível carregar os dados",
              style: TextStyle(
                color: Theme.of(context).primaryColorLight,
                fontWeight: FontWeight.bold,
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final todoList = snapshot.data;
          if (todoList!.isEmpty) {
            return const Center(
              child: Text("Sem dados"),
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
            bloc.inputTodo.add(DeleteTodoEvent(todo: todo));
          },
          child: ListTile(
            title: Text((todo.title == null) ? 'Sem título' : todo.title!),
            subtitle: Text(todo.uid.toString()),
          ),
        ),
      ),
    );
  }
}
