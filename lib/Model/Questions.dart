import 'package:flutter/material.dart';


class Questions extends StatefulWidget {
  Questions({Key key}) : super(key: key);

  @override
  _QuestionsState createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference questions = firestore.collection('Question');


    return Container();
  }
}