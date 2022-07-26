import '../models/todo_model.dart';

abstract class TodoEvent {}

class LoadTodoEvent extends TodoEvent {}

class AddTodoEvent extends TodoEvent {
  TodoModel todo;

  AddTodoEvent({required this.todo});
}

class UpdateTodoEvent extends TodoEvent {
  TodoModel todo;

  UpdateTodoEvent({required this.todo});
}

class DeleteTodoEvent extends TodoEvent {
  TodoModel todo;

  DeleteTodoEvent({required this.todo});
}
