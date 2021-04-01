import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestionPage extends StatefulWidget {
  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController txtanswer = TextEditingController();
  int level = 1;
  int maxlevel = 10;
  double opacity;
  bool isCorrect = false;
  bool isWrong = false;
  bool isMaxVisible = false;

  void saveData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt('Level', level);
  }

  Future<int> getLevel() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt('Level');
  }

  @override
  void initState() {
    super.initState();

    // SharedPreferences.getInstance().then((value) => value.clear());
    SharedPreferences.getInstance().then((value) {
      setState(() {
        level = value.getInt('Level') ?? 1;
      });
    });
    changeCorrect();
    changeWrong();
  }

  changeCorrect() {
    return Future.delayed(Duration(seconds: 2), () {
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

  changeWrong() {
    Future.delayed(Duration(seconds: 2), () {
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

  @override
  Widget build(BuildContext context) {
    CollectionReference question = firestore.collection('Question');
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: level <= maxlevel
          ? AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                'Level ' + level.toString(),
              ),
            )
          : null,
      body: SingleChildScrollView(
          child: level <= maxlevel
              ? Stack(alignment: Alignment.center, children: [
                  Column(
                    children: [
                      StreamBuilder<QuerySnapshot>(
                          stream: question.where('No', isEqualTo: level).snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              return Column(
                                children:
                                    snapshot.data.docs.map((DocumentSnapshot document) {
                                  return Container(
                                    height: MediaQuery.of(context).size.height * 0.5,
                                    width: MediaQuery.of(context).size.width * 0.8,
                                    child: Image(
                                        image: NetworkImage(document.data()['Image'])),
                                  );
                                }).toList(),
                              );
                            } else {
                              return CircularProgressIndicator();
                            }
                          }),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            child: TextField(
                              keyboardType: TextInputType.name,
                              textCapitalization: TextCapitalization.characters,
                              controller: txtanswer,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.black12,
                                  hintText: "KETIK JAWABAN DISINI"),
                            ),
                            width: MediaQuery.of(context).size.width * 0.7,
                          ),
                          TextButton(
                              onPressed: () {
                                onPress();
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.blue)),
                              child: Text(
                                'JAWAB',
                                style: TextStyle(color: Colors.white),
                              ))
                        ],
                      ),
                    ],
                  ),
                  buildPopUpAnswer(),
                ])
              : buildMaxLevel()),
    );
  }

  Widget buildPopUpAnswer() {
    if (isCorrect == true) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: isCorrect,
              child: Text('Benar'),
            ),
          ],
        ),
      );
    }
    if (isWrong == true) {
      return Visibility(
        visible: isWrong,
        child: Center(
          child: Text('Salah'),
        ),
      );
    }
    return Center();
  }

  onPress() {
    firestore
        .collection('Question')
        .where('No', isEqualTo: level)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((DocumentSnapshot document) {
        if (document.data()['Answer'] == txtanswer.text && level < maxlevel) {
          txtanswer.clear();
          saveData();
          setState(() {
            isCorrect = true;
          });
          return level++;
        }
        if (document.data()['Answer'] != txtanswer.text) {
          txtanswer.clear();
          saveData();
          setState(() {
            isWrong = true;
          });
          return null;
        }
        if (document.data()['Answer'] == txtanswer.text && level > maxlevel) {
          saveData();
          setState(() {});
          return null;
        }
      });
    });
  }

  Widget buildMaxLevel() {
    return Center(child: Text('SELAMAT'));
  }
}
