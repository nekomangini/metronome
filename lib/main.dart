import 'package:flutter/material.dart';
import 'package:metronome/screens/metronome.dart';
import 'package:metronome/utils/colors.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: primaryColor,
        scaffoldBackgroundColor: backgroundColor,
      ),
      home: Metronome(),
    );
  }
}
