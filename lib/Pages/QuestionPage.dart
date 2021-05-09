import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  InterstitialAd _interstitialAd;
  bool _isInterstitialAdReady = false;
  BannerAd _bannerAd;
  bool _isBannerAdReady = false;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController txtanswer = TextEditingController();
  double opacity;
  int level = 1;
  int maxlevel = 10;
  int lifeCount = 5;
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

    _interstitialAd = InterstitialAd(
      adUnitId: AdsHelper.interstitialAdUnitId,
      request: AdRequest(),
      listener: AdListener(
        onAdLoaded: (_) {
          _isInterstitialAdReady = true;
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load an interstitial ad: ${err.message}');
          _isInterstitialAdReady = false;
          ad.dispose();
        },
      ),
    )..load();

    SharedPreferences.getInstance().then((value) => value.clear());
    SharedPreferences.getInstance().then((value) {
      setState(() {
        level = value.getInt('Level') ?? 1;
        lifeCount = value.getInt('Life') ?? 5;
      });
    });
    changeCorrect();
    changeWrong();
    changeEmpty();
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

  onAdsLevel() {
    if (level % 5 == 0 && _isInterstitialAdReady) {
      _interstitialAd.show();
    }
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    _interstitialAd.show();
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
        title: Text('Level ' + level.toString()),
        flexibleSpace: buildHP(),
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
                              return Container(
                                height: MediaQuery.of(context).size.height * 0.5,
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Image(
                                  image: NetworkImage(document.data()['Image']),
                                ),
                              );
                            }).toList(),
                          );
                        } else {
                          return CircularProgressIndicator();
                        }
                      }),
                  if (_isBannerAdReady)
                    Container(
                      width: _bannerAd.size.width.toDouble(),
                      height: _bannerAd.size.height.toDouble(),
                      child: AdWidget(ad: _bannerAd),
                    ),
                  buildBotNavBar(),
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
      AudioService.sfx.wrong(isPlaySfx);
      return Visibility(
        visible: isGameOver,
        child: AlertDialog(
          title: Text('GAMEOVER'),
          actions: <Widget>[
            GameButton(
                widht: 200,
                height: 100,
                hover: Colors.red.withOpacity(0.7),
                image: "assets/images/buttons/Restart.png",
                onPress: () {
                  _interstitialAd.load();
                  AudioService.sfx.click(isPlaySfx);
                  Navigator.of(context).pushReplacementNamed('Question');
                  SharedPreferences.getInstance().then((value) => value.clear());
                }),
            GameButton(
                widht: 200,
                height: 100,
                hover: Colors.red.withOpacity(0.7),
                image: "assets/images/buttons/Quit.png",
                onPress: () {
                  if (_isInterstitialAdReady) {
                    _interstitialAd.show();
                    AudioService.sfx.click(isPlaySfx);
                    Navigator.of(context).pushNamed('Home');
                  } else {
                    AudioService.sfx.click(isPlaySfx);
                    Navigator.of(context).pushNamed('Home');
                  }
                }),
          ],
        ),
      );
    }

    // Widget untuk menampilkan tampilan ketika berhasil menang
    if (isWinning == true) {
      AudioService.sfx.correct(isPlaySfx);
      return Visibility(
        visible: isWinning,
        child: AlertDialog(
          title: Text('VICTORY'),
          actions: <Widget>[
            GameButton(
                widht: 200,
                height: 100,
                hover: Colors.red.withOpacity(0.7),
                image: "assets/images/buttons/Restart.png",
                onPress: () {
                  if (_isInterstitialAdReady) {
                    _interstitialAd.show();
                    AudioService.sfx.click(isPlaySfx);
                    Navigator.of(context).pushReplacementNamed('Question');
                    SharedPreferences.getInstance().then((value) => value.clear());
                  } else {
                    AudioService.sfx.click(isPlaySfx);
                    Navigator.of(context).pushReplacementNamed('Question');
                    SharedPreferences.getInstance().then((value) => value.clear());
                  }
                }),
            GameButton(
                widht: 200,
                height: 100,
                hover: Colors.red.withOpacity(0.7),
                image: "assets/images/buttons/Quit.png",
                onPress: () {
                  if (_isInterstitialAdReady) {
                    _interstitialAd.show();
                    AudioService.sfx.click(isPlaySfx);
                    Navigator.of(context).pushNamed('Home');
                  } else {
                    AudioService.sfx.click(isPlaySfx);
                    Navigator.of(context).pushNamed('Home');
                  }
                }),
          ],
        ),
      );
    }

    // Widget untuk menampilkan tampilan ketika jawaban masih kosong
    if (isEmptyAnswer == true) {
      AudioService.sfx.wrong(isPlaySfx);
      return Visibility(
        visible: isEmptyAnswer,
        child: Center(
          child: Text('JAWABAN MASIH KOSONG'),
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
          if (lifeCount <= 0) {
            isGameOver = true;
          } else {
            AudioService.sfx.wrong(isPlaySfx);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.white,
                elevation: 4,
                content: Center(
                  child: Text(
                    'Jawaban Masih Kosong',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            );
          }
          return null;
        }

        // Ketika Jawaban Betul dan Masih belum level maks
        if (document.data()['Answer'] == txtanswer.text && level <= maxlevel) {
          txtanswer.clear();
          onAdsLevel();
          saveData();
          setState(() {
            if (level <= maxlevel) {
              level++;
              isCorrect = true;
            }
            if (level > maxlevel) {
              isWinning = true;
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
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1,
      child: Row(
        children: [
          Stack(children: [
            // HP yang tetap berjumlah lima
            SizedBox(
              height: 50,
              width: 125,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  return Icon(
                    Icons.favorite,
                    color: Colors.grey,
                  );
                },
              ),
            ),
            // HP yang akan berkurang ketika jawaban salah
            SizedBox(
              height: 50,
              width: 125,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: lifeCount,
                itemBuilder: (BuildContext context, int index) {
                  return Icon(
                    Icons.favorite,
                    color: Colors.pink,
                  );
                },
              ),
            ),
          ]),
        ],
      ),
    );
  }

  Widget buildBotNavBar() {
    return Row(
      children: [
        SizedBox(
          child: TextFormField(
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.none,
            controller: txtanswer,
            cursorColor: Colors.black,
            onChanged: (value) {
              if (txtanswer.text != value.toUpperCase())
                txtanswer.value = txtanswer.value.copyWith(text: value.toUpperCase());
            },
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.black12,
                hintText: "KETIK JAWABAN DISINI"),
          ),
          width: MediaQuery.of(context).size.width * 0.7,
        ),
        GameButton(
          onPress: () {
            onPress();
            setState(() {});
          },
          widht: MediaQuery.of(context).size.width * 0.1,
          height: 60,
          hover: Colors.red.withOpacity(0.7),
          image: "assets/images/buttons/Jawab.png",
        )
      ],
    );
  }
}
