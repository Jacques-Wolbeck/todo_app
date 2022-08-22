import 'package:equatable/equatable.dart';

import '../models/todo_model.dart';

abstract class TodosState extends Equatable {
  const TodosState();

  @override
  List<Object> get props => [];
}

class TodosInitialState extends TodosState {}

class TodosLoading extends TodosState {}

class TodosLoaded extends TodosState {
  final List<TodoModel> todos;

  const TodosLoaded({this.todos = const <TodoModel>[]});

  @override
  List<Object> get props => [todos];
}

class TodosError extends TodosState {}
