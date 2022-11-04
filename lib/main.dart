import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:tdd_clean_architecture_number_trivia/features/number_trivia/presentation/pages/number_trivia_page.dart';
import './injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

const Color greenColor = Color(0XFF1B8817);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: greenColor,
        primarySwatch: Colors.green,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: greenColor),
        appBarTheme: const AppBarTheme(backgroundColor: greenColor),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0)),
            backgroundColor: MaterialStateProperty.all(greenColor),
          ),
        ),
      ),
      title: 'Number Trivia',
      home: const NumberTriviaPage(),
    );
  }
}
