import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/android/widgets/tabs/app_tab_bar.dart';

import '../../shared/blocs/todos_bloc.dart';
import '../../shared/blocs/todos_event.dart';
import '../../shared/blocs/todos_state.dart';
import '../../shared/models/todo_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  List<TodoModel> deleteList = [];

  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('ToDo'),
      ),
      bottomNavigationBar: AppTabBar(
        tabController: _tabController,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_body(Status.inProgress), _body(Status.finished)],
      ),
      floatingActionButton: Visibility(
        visible: deleteList.isNotEmpty,
        child: _deleteButton(),
      ),
    );
  }

  _body(Status statusState) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height * .1),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  //spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: _addButton(),
          ),
        ),
        const SizedBox(height: 16.0),
        _showTodoList(statusState),
      ],
    );
  }

  Widget _showTodoList(Status statusState) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 150.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              //spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
              child: statusState == Status.inProgress
                  ? Text('In progress',
                      style: Theme.of(context).textTheme.bodyText1!.merge(
                            TextStyle(
                                color: Theme.of(context).colorScheme.primary),
                          ))
                  : Text('Finished',
                      style: Theme.of(context).textTheme.bodyText1!.merge(
                            TextStyle(
                                color: Theme.of(context).colorScheme.primary),
                          )),
            ),
            BlocBuilder<TodosBloc, TodosState>(
              builder: (context, state) {
                if (state is TodosLoading) {
                  return const Center(
                    heightFactor: 15.0,
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is TodosError) {
                  return Center(
                    heightFactor: 15.0,
                    child: Text("Unable to load data",
                        style: Theme.of(context).textTheme.bodyText1!),
                  );
                }
                if (state is TodosLoaded) {
                  final todoList = state.todos;
                  if (statusState == Status.finished) {
                    final List<TodoModel> inProgressList = [];
                    for (var todo in todoList) {
                      if (Status.stringToEnum(todo.status) == statusState) {
                        inProgressList.add(todo);
                      }
                    }
                    return _todosList(inProgressList);
                  } else {
                    final List<TodoModel> finishedList = [];
                    for (var todo in todoList) {
                      if (Status.stringToEnum(todo.status) == statusState) {
                        finishedList.add(todo);
                      }
                    }
                    return _todosList(finishedList);
                  }
                } else {
                  return Text('Something went wrong',
                      style: Theme.of(context).textTheme.bodyText1!);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _todosList(List<TodoModel> todoList) {
    return Visibility(
      visible: todoList.isNotEmpty,
      replacement: Center(
        heightFactor: 15.0,
        child: Text("No data", style: Theme.of(context).textTheme.bodyText1!),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: todoList.length,
        itemBuilder: (context, index) {
          return _card(todoList[index]);
        },
        separatorBuilder: (context, __) => Divider(
          color: Theme.of(context).colorScheme.outline,
        ),
      ),
    );
  }

  Widget _card(TodoModel todo) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 8.0,
      child: Material(
        borderRadius: BorderRadius.circular(8.0),
        color: deleteList.contains(todo)
            ? Theme.of(context).colorScheme.onPrimaryContainer
            : Theme.of(context).colorScheme.primaryContainer,
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
            } else {
              Navigator.pushNamed(context, '/edit', arguments: todo);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ListTile(
              textColor: deleteList.contains(todo)
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.onPrimaryContainer,
              leading: _cardLeading(todo),
              trailing: deleteList.contains(todo)
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.delete,
                          size: 20,
                          color: Theme.of(context).colorScheme.onPrimary),
                    )
                  : const SizedBox.shrink(),
              title: Text((todo.title == null) ? 'No title' : todo.title!),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text((todo.description == null)
                      ? 'No description'
                      : todo.description!),
                  Text((todo.creationDate == null)
                      ? 'No date'
                      : todo.creationDate!)
                ],
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
            ),
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
        icon: const Icon(Icons.check_box_outline_blank),
        color: Theme.of(context).colorScheme.onPrimary,
      );
    } else {
      return IconButton(
          onPressed: () {
            todo.status = Status.enumToString(Status.inProgress);
            context.read<TodosBloc>().add(UpdateTodo(todo: todo));
          },
          splashRadius: 8.0,
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.check_box),
          color: Theme.of(context).colorScheme.onPrimary);
    }
  }

  Widget _addButton() {
    return ElevatedButton(
      onPressed: () => Navigator.pushNamed(context, '/add'),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            'Create ToDo',
          ),
          Icon(
            Icons.add,
            size: 25.0,
          )
        ],
      ),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 5.0,
        minimumSize: const Size(double.infinity, 50),
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
        elevation: 5.0,
        maximumSize: const Size(200, 50),
        minimumSize: const Size(150, 50),
      ),
    );
  }
}
