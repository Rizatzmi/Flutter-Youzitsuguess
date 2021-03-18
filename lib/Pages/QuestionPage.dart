import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:youzitsuguess/Model/Questions.dart';

class QuestionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference question = firestore.collection('Question');
    TextEditingController txtanswer = TextEditingController();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          'Level ' + level.toString(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<DocumentSnapshot>(
                stream: question.doc(level.toString()).snapshots(),
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
                    Map<String, dynamic> data = snapshot.data.data();
                    return Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Image(image: NetworkImage(data['Image'])));
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: TextFormField(
                    controller: txtanswer,
                    cursorColor: Colors.amber,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black12,
                        hintText: "KETIK JAWABAN DISINI"),
                  ),
                  width: MediaQuery.of(context).size.width * 0.8,
                ), 
                TextButton(
                    onPressed: () {
                      question
                          .doc(level.toString())
                          .get()
                          .then((DocumentSnapshot document) {
                        if (document.data()['Answer'] == txtanswer.text) {
                          return print(level++ < document.data().length);
                        }
                      });
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
      ),
    );
  }
}
