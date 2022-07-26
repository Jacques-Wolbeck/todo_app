import '../models/todo_model.dart';

abstract class TodoState {
  List<TodoModel> todos;

  TodoState({required this.todos});
}

class TodoSuccessState extends TodoState {
  TodoSuccessState({required List<TodoModel> todos}) : super(todos: todos);
}
