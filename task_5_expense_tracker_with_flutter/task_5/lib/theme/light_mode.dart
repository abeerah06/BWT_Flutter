import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Colors.green.shade100,
    secondary: Colors.green.shade200,
    primary: Colors.green.shade50,
    onPrimary: Colors.green.shade900,
  ),
  textTheme: ThemeData.light().textTheme.apply(
        bodyColor: Colors.green.shade900,
        displayColor: Colors.black,
      ),
);
