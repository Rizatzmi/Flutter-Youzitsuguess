import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:youzitsuguess/Model/AudioService.dart';
import 'package:youzitsuguess/Model/Button.dart';
import 'package:youzitsuguess/Model/SFX.dart';
import 'package:url_launcher/url_launcher.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TextStyle defaultStyle = TextStyle(color: Colors.grey, fontSize: 16.0);
  TextStyle linkStyle = TextStyle(color: Colors.blue, fontSize: 16.0);
  int initialIndex = 0;
  bool isTutorial = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: messageBox,
      child: Scaffold(
        body: Stack(
          children: [
            Image.asset(
              "assets/images/Backgrounds.png",
              fit: BoxFit.fill,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GameButton(
                    widht: 120,
                    height: 80,
                    hover: Colors.red.withOpacity(0.7),
                    image: 'assets/images/buttons/Main.png',
                    onPress: () async {
                      AudioService.sfx.click(isPlaySfx);
                      Navigator.pushNamed(context, 'Question');
                    },
                  ),
                  GameButton(
                      widht: 120,
                      height: 80,
                      hover: Colors.red.withOpacity(0.7),
                      image: "assets/images/buttons/Pengaturan.png",
                      onPress: () {
                        pengaturan(context);
                        AudioService.sfx.click(isPlaySfx);
                      }),
                  GameButton(
                      widht: 120,
                      height: 80,
                      hover: Colors.red.withOpacity(0.7),
                      image: "assets/images/buttons/Credit.png",
                      onPress: () {
                        credit(context);
                        AudioService.sfx.click(isPlaySfx);
                      }),
                  SizedBox(
                    height: 150,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> messageBox() async => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 10,
          title: Text('Quit'),
          content: Text('Apakah anda yakin ingin keluar?'),
          actions: <Widget>[
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(
                    width: 2,
                    color: Colors.black,
                  ),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Ya',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  AudioService.sfx.click(isPlaySfx);
                  Navigator.of(context).pop(true);
                }),
            TextButton(
                style: TextButton.styleFrom(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Colors.redAccent),
                child: Text(
                  'Tidak',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  AudioService.sfx.click(isPlaySfx);
                  Navigator.of(context).pop(false);
                }),
          ],
        ),
      );

  pengaturan(context) {
    Alert(
      context: context,
      title: "PENGATURAN",
      style: AlertStyle(
        isButtonVisible: false,
        isCloseButton: true,
        alertElevation: 2.0,
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 2.0),
        child: Column(
          children: [
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Sound'),
                SizedBox(
                  width: 20,
                ),
                ToggleSwitch(
                  minWidth: 60.0,
                  fontSize: 16.0,
                  initialLabelIndex: initialIndex,
                  activeBgColor: Colors.red,
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.black,
                  inactiveFgColor: Colors.white,
                  labels: ['On', 'Off'],
                  onToggle: (index) {
                    setState(() {
                      initialIndex = index;
                    });
                    switch (initialIndex) {
                      case 0:
                        setState(() {
                          isPlaySfx = true;
                        });
                        break;
                      case 1:
                        setState(() {
                          isPlaySfx = false;
                        });
                        break;
                      default:
                    }
                  },
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: GameButton(
                widht: 100,
                height: 60,
                hover: Colors.red.withOpacity(0.7),
                image: "assets/images/buttons/Tentang.png",
                onPress: () async {
                  AudioService.sfx.click(isPlaySfx);
                  Navigator.pushNamed(context, 'Tentang');
                },
              ),
            )
          ],
        ),
      ),
      alertAnimation: fadeAlertAnimation,
    ).show();
  }

  Widget fadeAlertAnimation(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return Align(
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }

  credit(context) {
    Alert(
      style: AlertStyle(
        isButtonVisible: false,
        isCloseButton: true,
        alertElevation: 2.0,
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      context: context,
      title: "CREDIT",
      content: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 8.0),
        child: Column(
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Sound effects obtained from ",
                    style: defaultStyle,
                  ),
                  TextSpan(
                    text: "https://www.zapsplat.com",
                    style: linkStyle,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        _launchInBrowser("https://www.zapsplat.com");
                      },
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Character artist ",
                      style: defaultStyle,
                    ),
                    TextSpan(
                      text: "@arv_yuri",
                      style: linkStyle,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          _launchInBrowser("https://www.instagram.com/arv_yuri");
                        },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ).show();
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }
}
