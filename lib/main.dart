import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:youzitsuguess/Pages/CaraMainPage.dart';
import 'package:youzitsuguess/Pages/MainPage.dart';
import 'package:youzitsuguess/Pages/QuestionPage.dart';
import 'package:youzitsuguess/Pages/TentangPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
      routes: {
        'CaraMain': (context) => CaraMainPage(),
        'Question': (context) => QuestionPage(),
        'Tentang': (context) => TentangPage()
      },
      title: 'Youzitsu Guess',
      debugShowCheckedModeBanner: false,
    );
  }
}
