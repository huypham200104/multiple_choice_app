import 'package:flutter/material.dart';
import 'package:multiple_choice_app/music_player.dart';
import 'main_screen.dart';
import 'package:multiple_choice_app/music_player.dart';

void main() {
  runApp(const MyApp());
  startBackgroundMusic();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Siêu Toán Nhí',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto', // You can change this to your preferred font
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}