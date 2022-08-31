import 'package:flutter/material.dart';

class DefaultTextForm extends StatelessWidget {
  final Function(String?) onSaved;
  final String labelText;
  final String validatorText;
  final String initialValue;
  final int maxLines;
  final int maxLength;

  const DefaultTextForm(
      {Key? key,
      required this.onSaved,
      required this.labelText,
      required this.validatorText,
      this.initialValue = '',
      this.maxLines = 1,
      this.maxLength = 30})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      onSaved: onSaved,
      validator: ((String? value) {
        if (value!.isEmpty) {
          return validatorText;
        }
        return null;
      }),
      decoration: InputDecoration(
        labelText: labelText,
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          borderSide:
              BorderSide(color: Theme.of(context).colorScheme.secondary),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      maxLength: maxLength,
      maxLines: maxLines,
    );
  }
}
