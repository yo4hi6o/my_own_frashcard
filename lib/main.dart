import 'package:flutter/material.dart';
import 'package:my_own_frashcard/db/database.dart';
import 'package:my_own_frashcard/screens/home_screen.dart';


MyDataBase dataBase;

void main() {
  dataBase = MyDataBase();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "私だけの単語帳",
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: "Lanobe"
      ),
      home: HomeScreen(),
    );
  }
}
