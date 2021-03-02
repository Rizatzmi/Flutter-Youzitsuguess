import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youzitsuguess/Pages/MainPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Youzitsu Guess',
      debugShowCheckedModeBanner: true,
      home: MainPage(),
    );
  }
}
