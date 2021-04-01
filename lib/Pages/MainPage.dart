import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // AudioPlayer audioPlayer;

  // void pauseSound() async {
  //   await audioPlayer.pause();
  // }

  // void resumeSound() async {
  //   await audioPlayer.resume();
  // }
  //

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => showDialog(
          context: context,
          builder: (context) => AlertDialog(
                  title: Text('Apakah anda yakin ingin keluar?'),
                  actions: <Widget>[
                    TextButton(
                        child: Text('Ya'),
                        onPressed: () => Navigator.of(context).pop(true)),
                    TextButton(
                        child: Text('Tidak'),
                        onPressed: () => Navigator.of(context).pop(false)),
                  ])),
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              "assets/background.png",
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/Logo.png",
                  height: MediaQuery.of(context).size.height * 0.4,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(Size(150, 10)),
                          backgroundColor: MaterialStateProperty.all(Colors.grey[900]),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)))),
                      onPressed: () {
                        Navigator.pushNamed(context, 'Question');
                        // onload();
                        AssetsAudioPlayer.newPlayer().open(
                          Audio("assets\bensound-cute.mp3"),
                        );
                      },
                      child: Text(
                        'MULAI',
                        style:
                            TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    TextButton(
                      style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(Size(150, 10)),
                          backgroundColor: MaterialStateProperty.all(Colors.grey[900]),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)))),
                      onPressed: () {},
                      child: Text(
                        'KIRIM SOAL',
                        style:
                            TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(Size(150, 10)),
                          backgroundColor: MaterialStateProperty.all(Colors.grey[900]),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)))),
                      onPressed: () {
                        Navigator.pushNamed(context, 'CaraMain');
                      },
                      child: Text(
                        'CARA MAIN',
                        style:
                            TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    TextButton(
                      style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(Size(150, 10)),
                          backgroundColor: MaterialStateProperty.all(Colors.grey[900]),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)))),
                      onPressed: () {
                        Navigator.pushNamed(context, 'Tentang');
                      },
                      child: Text(
                        'TENTANG',
                        style:
                            TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
                      ),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
