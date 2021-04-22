import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:youzitsuguess/Model/AudioService.dart';
import 'package:youzitsuguess/Model/SFX.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int initialIndex = 0;
  bool isTutorial = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: messageBox,
      child: Scaffold(
        body: Stack(
          // alignment: Alignment.center,
          children: [
            Image.asset(
              "assets/images/Backgrounds.png",
              fit: BoxFit.fill,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image.asset(
                //   "assets/Logo.png",
                //   height: MediaQuery.of(context).size.height * 0.4,
                // ),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
                      buildButton(
                        'assets\images\buttons\Main.png',
                        () async {
                          AudioService.sfx.click(isPlaySfx);
                          Navigator.pushNamed(context, 'Question');
                        },
                      ),
                      buildButton('assets\images\buttons\Pengaturan.png', () {}),
                      buildButton('assets\images\buttons\Credit.png', () {})
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> messageBox() async => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Apakah anda yakin ingin keluar?'),
          actions: <Widget>[
            TextButton(
                child: Text('Ya'),
                onPressed: () {
                  AudioService.sfx.click(isPlaySfx);
                  Navigator.of(context).pop(true);
                }),
            TextButton(
                child: Text('Tidak'),
                onPressed: () {
                  AudioService.sfx.click(isPlaySfx);
                  Navigator.of(context).pop(false);
                }),
          ],
        ),
      );

  Widget buildButton(String image, Function callback) {
    return InkWell(
      onTap: callback,
      splashColor: Colors.grey.withOpacity(0.5),
      child: Ink(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  void openPengaturan(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.orange.shade700,
          content: Column(
            children: [
              Row(
                children: [
                  Text('Sound'),
                  SizedBox(
                    width: 10,
                  ),
                  ToggleSwitch(
                    minWidth: 90.0,
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
                      if (initialIndex == 0) {
                        setState(() {
                          isPlaySfx = true;
                        });
                      } else {
                        setState(() {
                          isPlaySfx = false;
                        });
                      }
                    },
                  )
                ],
              ),
              buildButton(
                'assets\images\buttons\Tentang.png',
                () async {
                  AudioService.sfx.click(isPlaySfx);
                  Navigator.pushNamed(context, 'Tentang');
                },
              )
            ],
          ),
        );
      },
    );
  }
}
