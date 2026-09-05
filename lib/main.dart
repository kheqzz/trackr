import 'package:flutter/material.dart';
import 'package:trackr/page/home_page.dart';

void main(List<String> args) {
  runApp(MyTrackerApp());
}

class MyTrackerApp extends StatelessWidget {
  const MyTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.deepPurple[50],
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
          primaryContainer: Colors.deepPurple[200],
          secondaryContainer: Colors.deepPurple[300],
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
          primaryContainer: Colors.deepPurple[500],
          secondaryContainer: Colors.deepPurple[400],
        ),
      ),

      themeMode: ThemeMode.light,
    );
  }
}
