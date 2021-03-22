import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestionPage extends StatefulWidget {
  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  TextEditingController txtanswer = TextEditingController();
  int level = 1;

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
    SharedPreferences.getInstance().then((value) {
      setState(() {
        level = value.getInt('Level') ?? 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference question = firestore.collection('Question');

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          'Level ' + level.toString(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: question.where('No', isEqualTo: level).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data.docs.map((DocumentSnapshot document) {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Image(image: NetworkImage(document.data()['Image'])),
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
                      question
                          .doc(level.toString())
                          .get()
                          .then((DocumentSnapshot document) {
                        if (document.data()['Answer'] == txtanswer.text &&
                            level < document.data().length) {
                          saveData();
                          setState(() {});
                          return level++;
                        }
                        if (document.data()['Answer'] == txtanswer.text &&
                            level == document.data().length) {
                          saveData();
                          setState(() {});
                          return Center(
                              child: AlertDialog(
                            title: Text('SELAMAT'),
                          ));
                        }
                      });
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue)),
                    child: Text(
                      'JAWAB',
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
