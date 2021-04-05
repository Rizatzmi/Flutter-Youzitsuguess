import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

int level = 1;

class Questions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference question = firestore.collection('Question');

    return StreamBuilder<QuerySnapshot>(
      stream: question.where('No', isEqualTo: level.toDouble()).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        final list = snapshot.data?.docs;

        return new ListView(
          children: list.map((DocumentSnapshot document) {
            return Image(image: NetworkImage(document.data()['Image'] ?? ""));
          }).toList(),
        );
      },
    );
  }
}
