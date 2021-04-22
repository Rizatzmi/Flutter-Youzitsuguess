import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:youzitsuguess/Pages/CaraMainPage.dart';
import 'package:youzitsuguess/Pages/MainPage.dart';
import 'package:youzitsuguess/Pages/QuestionPage.dart';
import 'package:youzitsuguess/Pages/TentangPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(dialogBackgroundColor: Colors.orange.shade700),
      home: AnimatedSplashScreen(
          splash: 'assets/images/Splashscreen.png',
          splashTransition: SplashTransition.fadeTransition,
          nextScreen: MainPage()),
      routes: {
        'CaraMain': (context) => CaraMainPage(),
        'Question': (context) => QuestionPage(),
        'Tentang': (context) => TentangPage(),
        'Home': (context) => MainPage()
      },
      title: 'Youzitsu Guess',
      debugShowCheckedModeBanner: false,
    );
  }
}
