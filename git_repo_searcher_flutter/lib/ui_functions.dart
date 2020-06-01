import 'package:flutter/material.dart';

void showExceptionSnackBar(Exception error, BuildContext context) =>
    Scaffold.of(context).showSnackBar(SnackBar(
      duration: Duration(milliseconds: 1000),
      content: Text(error.toString()),
    ));
