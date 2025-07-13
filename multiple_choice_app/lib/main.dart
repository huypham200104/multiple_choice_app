import 'package:flutter/material.dart';
import 'main_screen.dart';

void main() {
  runApp(const MyApp());
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