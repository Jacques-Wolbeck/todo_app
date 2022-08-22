import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../shared/blocs/todos_bloc.dart';
import '../../shared/blocs/todos_event.dart';
import '../../shared/blocs/todos_state.dart';
import '../../shared/models/todo_model.dart';

class AddScreen extends StatelessWidget {
  AddScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final todo = TodoModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo'),
      ),
      body: _body(context),
      floatingActionButton: BlocListener<TodosBloc, TodosState>(
        listener: (context, state) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Todo Added!')));
        },
        child: FloatingActionButton(
          child: Icon(
            Icons.save,
            color: Theme.of(context).primaryColorLight,
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              todo.status = 'em andamento';
              String formattedDate =
                  DateFormat('dd/MM/yyyy – HH:mm').format(DateTime.now());
              todo.creationDate = formattedDate;

              context.read<TodosBloc>().add(AddTodo(todo: todo));
              Navigator.pop(context);
            }
          },
          backgroundColor: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  _body(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Form(
            key: _formKey,
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onSaved: ((String? newValue) {
                      todo.title = newValue;
                    }),
                    validator: ((String? value) {
                      return (value == null)
                          ? 'Por favor digite um título'
                          : null;
                    }),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Título',
                      labelStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15.0)),
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onSaved: ((String? newValue) {
                      todo.description = newValue;
                    }),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Descrição',
                      labelStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                ),
              ],
            ))
      ],
    );
  }
}
