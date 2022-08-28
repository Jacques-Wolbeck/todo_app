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
  List deleteList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('ToDo'),
      ),
      body: _body(),
      floatingActionButton:
          deleteList.isNotEmpty ? _deleteButton() : const SizedBox.shrink(),
    );
  }

  _body() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
      children: [
        Row(
          children: [
            _addButton(),
          ],
        ),
        const SizedBox(height: 16.0),
        _showTodoList(),
      ],
    );
  }

  Widget _showTodoList() {
    return ConstrainedBox(
      constraints:
          BoxConstraints(minHeight: MediaQuery.of(context).size.height * .2),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onBackground,
          borderRadius: BorderRadius.circular(8.0),
        ),
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
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontSize: 16.0,
                  ),
                ),
              );
            }
            if (state is TodosLoaded) {
              final todoList = state.todos;
              debugPrint(todoList.length.toString());
              if (todoList.isEmpty) {
                return Center(
                  child: Text(
                    "No data",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontSize: 16.0,
                    ),
                  ),
                );
              }
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: todoList.length,
                itemBuilder: (context, index) {
                  return _cardTile(todoList[index]);
                },
                separatorBuilder: (context, __) => Divider(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              );
            } else {
              return Text(
                'Something went wrong',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontSize: 16.0,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _cardTile(TodoModel todo) {
    return Card(
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(8.0),
        color: deleteList.contains(todo)
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).colorScheme.onSecondary,
        child: InkWell(
          onLongPress: () {
            if (!deleteList.contains(todo)) {
              setState(() {
                deleteList.add(todo);
              });
            }
          },
          onTap: () {
            if (deleteList.isNotEmpty && !deleteList.contains(todo)) {
              setState(() {
                deleteList.add(todo);
              });
            } else if (deleteList.contains(todo)) {
              setState(() {
                deleteList.remove(todo);
              });
            }
          },
          child: ListTile(
            leading: _cardLeading(todo),
            trailing: deleteList.contains(todo)
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.delete,
                      size: 20,
                    ),
                  )
                : const SizedBox.shrink(),
            title: Text((todo.title == null) ? 'No title' : todo.title!),
            subtitle:
                Text((todo.creationDate == null) ? 'No date' : todo.status!),
          ),
        ),
      ),
    );
  }

  Widget _cardLeading(TodoModel todo) {
    if (Status.finished != Status.stringToEnum(todo.status)) {
      return IconButton(
          onPressed: () {
            todo.status = Status.enumToString(Status.finished);
            context.read<TodosBloc>().add(UpdateTodo(todo: todo));
          },
          splashRadius: 8.0,
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.check_box_outline_blank));
    } else {
      return IconButton(
          onPressed: () {
            todo.status = Status.enumToString(Status.inProgress);
            context.read<TodosBloc>().add(UpdateTodo(todo: todo));
          },
          splashRadius: 8.0,
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.check_box));
    }
  }

  Widget _addButton() {
    return InkWell(
      borderRadius: BorderRadius.circular(8.0),
      onTap: () => Navigator.pushNamed(context, '/add'),
      highlightColor: Theme.of(context).colorScheme.secondary,
      child: Ink(
        height: MediaQuery.of(context).size.height * .1,
        width: MediaQuery.of(context).size.width * .3,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onBackground,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Create ToDo',
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onSecondary),
            ),
            Icon(
              Icons.add,
              size: 30.0,
              color: Theme.of(context).colorScheme.onSecondary,
            )
          ],
        ),
      ),
    );
  }

  Widget _deleteButton() {
    return ElevatedButton(
      onPressed: () {
        for (var element in deleteList) {
          context.read<TodosBloc>().add(DeleteTodo(todo: element));
        }
        setState(() {
          deleteList.clear();
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Icon(
            Icons.delete,
          ),
          const Text(
            'Delete all',
          ),
          Container(
            alignment: Alignment.center,
            width: 25.0,
            height: 25.0,
            decoration: BoxDecoration(
              color: Theme.of(context).focusColor,
              shape: BoxShape.circle,
            ),
            child: Text(
              deleteList.length.toString(),
            ),
          ),
        ],
      ),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        maximumSize: const Size(200, 50),
        minimumSize: const Size(150, 50),
      ),
    );
  }
}
