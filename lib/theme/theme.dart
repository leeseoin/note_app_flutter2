import 'package:flutter/material.dart';

// light mode
ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: const Color(0xFFF5F5DC),
    primary: const Color(0xFFD3D3D3),
    secondary: Colors.grey.shade300,
    inversePrimary: Colors.grey.shade800,
  ),
);

// dark mode
ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: const Color.fromARGB(255, 15, 15, 15),
    primary: Colors.grey.shade800,
    secondary: Colors.grey.shade700,
    inversePrimary: Colors.grey.shade300,
  ),
);
