import 'package:flutter/material.dart';
import 'package:flutter_mobile_vision_example/ListView/home_page.dart';

void main() => runApp(MainActivity());

class MainActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Flutter Demo",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage());
  }
}