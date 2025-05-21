import 'package:flutter/material.dart';
import 'package:weather_app/view/screens/home/home_screen.dart';

import 'core/style/colors.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: lightBlueBackground
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
