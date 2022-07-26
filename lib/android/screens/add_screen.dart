import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../shared/blocs/todos_bloc.dart';
import '../../shared/blocs/todos_event.dart';
import '../../shared/blocs/todos_state.dart';
import '../../shared/models/todo_model.dart';
import '../widgets/forms/default_text_form.dart';

class AddScreen extends StatelessWidget {
  AddScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final todo = TodoModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo'),
      ),
      body: _body(context),
      floatingActionButton: BlocListener<TodosBloc, TodosState>(
        listener: (context, state) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Todo added!')));
        },
        child: FloatingActionButton(
          child: const Icon(
            Icons.save,
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              todo.status = Status.enumToString(Status.inProgress);
              String formattedDate =
                  DateFormat('dd/MM/yyyy – HH:mm').format(DateTime.now());
              todo.creationDate = formattedDate;

              context.read<TodosBloc>().add(AddTodo(todo: todo));
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }

  _body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
      child: Form(
        autovalidateMode: AutovalidateMode.always,
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Create your ToDo',
                style: Theme.of(context).textTheme.bodyText1!.merge(
                    TextStyle(color: Theme.of(context).colorScheme.primary)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: DefaultTextForm(
                  onSaved: (String? newValue) => todo.title = newValue,
                  labelText: 'Title',
                  validatorText: 'Please enter a title'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: DefaultTextForm(
                onSaved: (String? newValue) => todo.description = newValue,
                labelText: 'Description',
                validatorText: 'Please enter a description',
                maxLines: 5,
                maxLength: 150,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
