import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/android/widgets/forms/default_text_form.dart';

import '../../shared/blocs/todos_bloc.dart';
import '../../shared/blocs/todos_event.dart';
import '../../shared/blocs/todos_state.dart';
import '../../shared/models/todo_model.dart';

class EditScreen extends StatelessWidget {
  EditScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final todo = ModalRoute.of(context)!.settings.arguments as TodoModel;
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo'),
      ),
      body: _body(context, todo),
      floatingActionButton: BlocListener<TodosBloc, TodosState>(
        listener: (context, state) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Todo edited!')));
        },
        child: FloatingActionButton(
          child: const Icon(
            Icons.edit,
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              context.read<TodosBloc>().add(UpdateTodo(todo: todo));
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }

  _body(BuildContext context, TodoModel todo) {
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
                'Edit your ToDo',
                style: Theme.of(context).textTheme.bodyText1!.merge(
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: DefaultTextForm(
                  onSaved: (String? newValue) => todo.title = newValue,
                  labelText: 'Título',
                  validatorText: 'Please enter a title',
                  initialValue: todo.title!),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: DefaultTextForm(
                onSaved: (String? newValue) => todo.description = newValue,
                labelText: 'Description',
                validatorText: 'Please enter a description',
                maxLines: 5,
                maxLength: 150,
                initialValue: todo.description!,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
