import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/blocs/todos_bloc.dart';
import '../../shared/blocs/todos_event.dart';
import '../../shared/blocs/todos_state.dart';
import '../../shared/models/todo_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
          Navigator.pushNamed(context, '/add');
        },
        backgroundColor: Theme.of(context).primaryColorLight,
      ),
    );
  }

  _body() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text('Allllooo'),
            Expanded(
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
                    return ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
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
            ),
          ],
        ),
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
            subtitle: Text((todo.description == null)
                ? 'No description'
                : todo.description!),
          ),
        ),
      ),
    );
  }
}
