import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionPage extends StatefulWidget {
  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  TextEditingController txtanswer = TextEditingController();
  int level = 1;
  String image;

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    Query question =
        firestore.collection('Question').where('No', isEqualTo: level);

    return Column(
      children: [
        Row(
          children: [
            Text(
              'Level ' + level.toString(),
              style: TextStyle(fontSize: 10),
            )
          ], // State
        ),
        Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 1,
            child: StreamBuilder<QuerySnapshot>(
                stream: question.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    snapshot.data.docs.map((DocumentSnapshot document) {
                      return Image(
                        image: NetworkImage(document.data()['Image']),
                      );
                    });
                  }
                  return Text('');
                })),
        Row(
          children: [
            TextField(
              controller: txtanswer,
              decoration: InputDecoration(hintText: "KETIK JAWABAN DISINI"),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: question.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    snapshot.data.docs.map((DocumentSnapshot document) {
                      return FlatButton(
                        onPressed: () {
                          if (txtanswer.text == document.data()['Answer']) {
                            level + 1;
                          }
                        },
                        child: Text("JAWAB"),
                      );
                    });
                  }
                  return Text('');
                }) // State
          ],
        )
      ],
    );
  }
}
