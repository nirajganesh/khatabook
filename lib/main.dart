import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:khatabook/sample.dart';
import 'package:khatabook/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.yellow,
      ),
      home:splash_screen(),
    );
  }
}


