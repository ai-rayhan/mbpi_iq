import 'package:flutter/material.dart';

 Future pickDate(context)async {
  return showDatePicker(
    context: context,
    firstDate: DateTime.now().subtract(const Duration(days: 365)),
    lastDate: DateTime.now().add(const Duration(days: 365)),
    initialDate: DateTime.now(),
  );
}
