import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:youzitsuguess/Pages/CaraMainPage.dart';
import 'package:youzitsuguess/Pages/MainPage.dart';
import 'package:youzitsuguess/Pages/QuestionPage.dart';
import 'package:youzitsuguess/Pages/TentangPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MobileAds.instance.initialize();
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
      home: AnimatedSplashScreen(
          duration: 1000,
          animationDuration: Duration(seconds: 1),
          splash: 'assets/images/Splashscreen.png',
          splashIconSize: double.infinity,
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
