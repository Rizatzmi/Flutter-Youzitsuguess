import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:youzitsuguess/Model/AudioService.dart';
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

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  AudioPlayer advancedplayer;
  AudioCache audioCache;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      audioCache.fixedPlayer.pause();
    }
    if (state == AppLifecycleState.resumed) {
      audioCache.fixedPlayer.resume();
    } else {}
  }

  @override
  void initState() {
    super.initState();
    _bgm();
    WidgetsBinding.instance.addObserver(this);
  }

  Future<dynamic> _bgm() async {
    advancedplayer = AudioPlayer();
    audioCache = AudioCache(fixedPlayer: advancedplayer);
    audioCache.play('audios/bensound-cute.mp3');
    audioCache.fixedPlayer.setReleaseMode(ReleaseMode.LOOP);
  }

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
