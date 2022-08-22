import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../database/database_controller.dart';
import 'todos_event.dart';
import 'todos_state.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  final DatabaseController dbInstance;

  TodosBloc({required this.dbInstance}) : super(TodosInitialState()) {
    // todos events
    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodo);
    on<UpdateTodo>(_onUpdateTodo);
    on<DeleteTodo>(_onDeleteTodo);
  }

  void _onLoadTodos(LoadTodos event, Emitter<TodosState> emit) async {
    emit(TodosLoading());
    try {
      final todos = await dbInstance.getAllTodos();
      emit(TodosLoaded(todos: todos));
    } catch (error) {
      debugPrint(error.toString());
      emit(TodosError());
    }
  }

  void _onAddTodo(AddTodo event, Emitter<TodosState> emit) async {
    final state = this.state;
    try {
      if (state is TodosLoaded) {
        await dbInstance.insertTodo(event.todo);
        final todos = await dbInstance.getAllTodos();
        emit(TodosLoaded(todos: todos));
      }
    } catch (error) {
      debugPrint(error.toString());
      emit(TodosError());
    }
  }

  void _onUpdateTodo(UpdateTodo event, Emitter<TodosState> emit) async {
    final state = this.state;
    try {
      if (state is TodosLoaded) {
        await dbInstance.updateTodo(event.todo);
        final todos = await dbInstance.getAllTodos();
        emit(TodosLoaded(todos: todos));
      }
    } catch (error) {
      debugPrint(error.toString());
      emit(TodosError());
    }
  }

  void _onDeleteTodo(DeleteTodo event, Emitter<TodosState> emit) async {
    final state = this.state;
    try {
      if (state is TodosLoaded) {
        await dbInstance.deleteTodo(event.todo);
        final todos = await dbInstance.getAllTodos();
        emit(TodosLoaded(todos: todos));
      }
    } catch (error) {
      debugPrint(error.toString());
      emit(TodosError());
    }
  }
}
