import 'dart:async';

import 'package:todo_app/blocs/todo_event.dart';
import 'package:todo_app/database/database_controller.dart';
import 'package:todo_app/models/todo_model.dart';

class TodoBloc {
  final StreamController<TodoEvent> _inputTodoController =
      StreamController<TodoEvent>.broadcast();
  final StreamController<List<TodoModel>> _outputTodoController =
      StreamController<List<TodoModel>>();

  Sink<TodoEvent> get inputTodo => _inputTodoController.sink;
  Stream<List<TodoModel>> get stream => _outputTodoController.stream;

  TodoBloc() {
    _inputTodoController.stream.listen((_mapEventToState));
  }

  _mapEventToState(TodoEvent event) async {
    List<TodoModel> todos = [];

    if (event is LoadTodoEvent) {
      todos = await DatabaseController.db.getAllTodos();
    } else {
      if (event is AddTodoEvent) {
        await DatabaseController.db.insertTodo(event.todo);
      } else if (event is UpdateTodoEvent) {
        await DatabaseController.db.updateTodo(event.todo);
      } else if (event is DeleteTodoEvent) {
        await DatabaseController.db.deleteTodo(event.todo);
      }
      todos = await DatabaseController.db.getAllTodos();
    }

    _outputTodoController.add(todos);
  }
}
