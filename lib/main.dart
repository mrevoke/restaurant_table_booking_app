import 'package:flutter/material.dart';
import 'package:restaurant/Home_Screen.dart';
import 'package:restaurant/dbhelper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}
