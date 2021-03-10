import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Questions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference question =
        firestore.collection('Question').where('No', isEqualTo: 1);

    return StreamBuilder<QuerySnapshot>(
      stream: question.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        final list = snapshot.data.docs;

        return new ListView(
          children: list.map((DocumentSnapshot document) {
            return Column(children: [
              Image(image: NetworkImage(document.data()['Image'] ?? "")),
              Text(document.data()['Answer'])
            ]);
          }).toList(),
        );
      },
    );
  }
}
