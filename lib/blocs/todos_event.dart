import 'package:equatable/equatable.dart';
import 'package:todo_app/models/todo_model.dart';

abstract class TodosEvent extends Equatable {
  const TodosEvent();

  @override
  List<Object> get props => [];
}

class LoadTodos extends TodosEvent {
  final List<TodoModel> todos;

  const LoadTodos({this.todos = const <TodoModel>[]});

  @override
  List<Object> get props => [todos];
}

class AddTodo extends TodosEvent {
  final TodoModel todo;

  const AddTodo({required this.todo});

  @override
  List<Object> get props => [todo];
}

class UpdateTodo extends TodosEvent {
  final TodoModel todo;

  const UpdateTodo({required this.todo});

  @override
  List<Object> get props => [todo];
}

class DeleteTodo extends TodosEvent {
  final TodoModel todo;

  const DeleteTodo({required this.todo});

  @override
  List<Object> get props => [todo];
}
