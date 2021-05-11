import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youzitsuguess/Model/Ads_Service.dart';
import 'package:youzitsuguess/Model/AudioService.dart';
import 'package:youzitsuguess/Model/Button.dart';
import 'package:youzitsuguess/Model/SFX.dart';

class QuestionPage extends StatefulWidget {
  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController txtanswer = TextEditingController();

  BannerAd _bannerAd;
  int level = 1;
  int maxlevel = 10;
  int lifeCount = 5;
  int levelAppbar;
  bool _isBannerAdReady = false;
  bool isGameOver = false;
  bool isCorrect = false;
  bool isWrong = false;
  bool isMaxVisible = false;
  bool isWinning = false;
  bool isEmptyAnswer = false;

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: AdsHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: AdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd.load();

    SharedPreferences.getInstance().then((value) => value.clear());
    SharedPreferences.getInstance().then((value) {
      setState(() {
        level = value.getInt('Level') ?? 10;
        lifeCount = value.getInt('Life') ?? 5;
      });
    });
    changeCorrect();
    changeWrong();
    changeEmpty();
    leveltitle();
  }

  // Method Save Data Variabel Level dan jumlah Nyawa yang tersisa
  void saveData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt('Level', level);
    pref.setInt('Life', lifeCount);
  }

  changeEmpty() {
    return Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          isEmptyAnswer = isEmptyAnswer == true ? false : false;
          changeEmpty();
        });
      }
      if (!mounted) {
        return null;
      }
    });
  }

  // Method untuk membuat Widget yang tampil ketika jawaban benar menjadi sebuah pop up
  changeCorrect() {
    return Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          isCorrect = isCorrect == true ? false : false;
          changeCorrect();
        });
      }
      if (!mounted) {
        return null;
      }
    });
  }

  // Method untuk membuat Widget yang tampil ketika jawaban salah menjadi sebuah pop up
  changeWrong() {
    return Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          isWrong = isWrong == true ? false : false;
          changeWrong();
        });
      }
      if (!mounted) {
        return null;
      }
    });
  }

  changeisWinning() {
    if (level > maxlevel) {
      setState(() {
        isWinning = true;
      });
    }
  }

  // Method untuk mengurangi HP ketika jawaban salah
  decreaseHp() {
    if (lifeCount > 0) lifeCount--;
  }

  leveltitle() {
    if (level <= 11) {
      levelAppbar = 10;
    } else {
      levelAppbar = level;
    }
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference question = firestore.collection('Question');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // Untuk Menghilangkan Tanda Panah Back
        automaticallyImplyLeading: false,
        backgroundColor: Colors.red.shade600,
        title: Text(
          'Level ' + levelAppbar.toString(),
        ),
        actions: [
          buildHP(),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
            // alignment: Alignment.center,
            children: [
              Image.asset(
                "assets/images/Background.png",
                fit: BoxFit.fill,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
              ),
              Column(
                children: [
                  StreamBuilder<QuerySnapshot>(
                      stream: question.where('No', isEqualTo: level).snapshots(),
                      builder:
                          (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            children: snapshot.data.docs.map((DocumentSnapshot document) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: MediaQuery.of(context).size.height * 0.4,
                                  width: MediaQuery.of(context).size.width * 0.8,
                                  child: Image(
                                    image: NetworkImage(document.data()['Image']),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        } else {
                          return CircularProgressIndicator();
                        }
                      }),
                  if (level < 11) buildBotNavBar(),
                  if (_isBannerAdReady)
                    Container(
                      width: _bannerAd.size.width.toDouble(),
                      height: _bannerAd.size.height.toDouble(),
                      child: AdWidget(ad: _bannerAd),
                    ),
                ],
              ),
              buildPopUp()
            ]),
      ),
    );
  }

  // Widget untuk menampilan Pop Up ketika Jawaban salah, Jawaban benar, dan ketika Game Over
  Widget buildPopUp() {
    // Widget yang muncul ketika jawaban benar
    if (isCorrect == true) {
      AudioService.sfx.correct(isPlaySfx);
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: isCorrect,
              child: Image.asset("assets/images/popups/Benar.png"),
            ),
          ],
        ),
      );
    }

    // Widget yang muncul ketika jawaban salah
    if (isWrong == true) {
      AudioService.sfx.wrong(isPlaySfx);
      return Visibility(
        visible: isWrong,
        child: Center(
          child: Image.asset("assets/images/popups/Salah.png"),
        ),
      );
    }

    // Widget yang muncul ketika Game Over
    if (isGameOver == true) {
      return Visibility(
        visible: isGameOver,
        child: Stack(
          children: [
            Center(
                child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset("assets/images/Gameover.png"),
            )),
            Positioned(
              bottom: 200,
              left: 110,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GameButton(
                      widht: 150,
                      height: 75,
                      hover: Colors.red.withOpacity(0.7),
                      image: "assets/images/buttons/Restart.png",
                      onPress: () {
                        AudioService.sfx.click(isPlaySfx);
                        Navigator.of(context).pushReplacementNamed('Question');
                        SharedPreferences.getInstance().then((value) => value.clear());
                      }),
                  GameButton(
                      widht: 150,
                      height: 75,
                      hover: Colors.red.withOpacity(0.7),
                      image: "assets/images/buttons/Quit.png",
                      onPress: () {
                        AudioService.sfx.click(isPlaySfx);
                        Navigator.of(context).pushNamed('Home');
                      }),
                ],
              ),
            )
          ],
        ),
      );
    }

    // Widget untuk menampilkan tampilan ketika berhasil menang
    if (isWinning == true) {
      return Visibility(
        visible: isWinning,
        child: Stack(
          children: [
            Center(
                child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset("assets/images/Victory.png"),
            )),
            Positioned(
              bottom: 200,
              left: 110,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GameButton(
                      widht: 150,
                      height: 75,
                      hover: Colors.red.withOpacity(0.7),
                      image: "assets/images/buttons/Restart.png",
                      onPress: () {
                        AudioService.sfx.click(isPlaySfx);
                        Navigator.of(context).pushReplacementNamed('Question');
                        SharedPreferences.getInstance().then((value) => value.clear());
                      }),
                  GameButton(
                      widht: 150,
                      height: 75,
                      hover: Colors.red.withOpacity(0.7),
                      image: "assets/images/buttons/Quit.png",
                      onPress: () {
                        AudioService.sfx.click(isPlaySfx);
                        Navigator.of(context).pushNamed('Home');
                      }),
                ],
              ),
            )
          ],
        ),
      );
    }

    return Center();
  }

  // Method OnPressed Button Jawab
  onPress() async {
    firestore
        .collection('Question')
        .where('No', isEqualTo: level)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((DocumentSnapshot document) {
        // Ketika jawaban kosong
        if (txtanswer.text == "") {
          if (lifeCount == 1) {
            lifeCount--;
            isGameOver = true;
            AudioService.sfx.wrong(isPlaySfx);
          } else {
            AudioService.sfx.wrong(isPlaySfx);
            lifeCount--;
            Fluttertoast.showToast(
              msg: "Jawaban Masih Kosong",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
            );
          }
          return null;
        }

        // Ketika Jawaban Betul dan Masih belum level maks
        if (document.data()['Answer'] == txtanswer.text && level <= maxlevel) {
          txtanswer.clear();

          saveData();
          setState(() {
            if (level <= maxlevel) {
              level++;
              isCorrect = true;
            }
            if (level > maxlevel) {
              isWinning = true;
              AudioService.sfx.correct(isPlaySfx);
            }
          });
          return null;
        }

        // Ketika Jawaban Salah
        if (document.data()['Answer'] != txtanswer.text) {
          txtanswer.clear();
          SharedPreferences.getInstance().then((value) => value.clear());
          saveData();
          decreaseHp();
          setState(() {
            if (lifeCount <= 0) {
              isGameOver = true;
            } else {
              lifeCount--;
              isWrong = true;
            }
          });
          return null;
        }
      });
    });
  }

  // Widget untuk menampilkan bar nyawa kita
  Widget buildHP() {
    return Row(
      children: [
        SizedBox(
          height: 50,
          width: 125,
          child: ListView.builder(
            reverse: true,
            scrollDirection: Axis.horizontal,
            itemCount: lifeCount,
            itemBuilder: (BuildContext context, int index) {
              return Icon(
                Icons.favorite,
                color: Colors.white,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildBotNavBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            height: 40,
            child: TextFormField(
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.none,
              controller: txtanswer,
              cursorColor: Colors.black,
              onChanged: (value) {
                if (txtanswer.text != value.toUpperCase())
                  txtanswer.value = txtanswer.value.copyWith(
                    text: value.toUpperCase(),
                  );
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.white,
                hintText: "KETIK JAWABAN DISINI",
              ),
            ),
          ),
          GameButton(
            onPress: () {
              onPress();
              setState(() {});
            },
            widht: 80,
            height: 40,
            hover: Colors.red.withOpacity(0.7),
            image: "assets/images/buttons/Jawab.png",
          )
        ],
      ),
    );
  }
}
