import 'package:flutter/material.dart';

void showSnackBar({required String message,context,bool? haserror}) {
  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor: haserror!=null?Colors.red:null
  );

  final scaffoldMessenger = ScaffoldMessenger.of(context);
  scaffoldMessenger.showSnackBar(snackBar);
}
