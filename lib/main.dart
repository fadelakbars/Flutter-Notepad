import 'package:flutter/material.dart';
import 'package:notes_making/pages/NoteList.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Onyx Note',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color.fromRGBO(26, 37, 60, 1),
        scaffoldBackgroundColor: Color.fromRGBO(26, 37, 60, 1),
        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromRGBO(26, 37, 60, 1),
        ),
        tooltipTheme: TooltipThemeData(
          textStyle: TextStyle(color: Colors.white), // Warna teks tooltip
          decoration: BoxDecoration(
            color: Colors.white, // Warna latar belakang tooltip
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
      home: NoteList(),
    );
  }
}