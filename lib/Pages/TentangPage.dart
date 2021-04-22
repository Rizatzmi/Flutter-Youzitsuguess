import 'package:flutter/material.dart';

class TentangPage extends StatefulWidget {
  @override
  _TentangPageState createState() => _TentangPageState();
}

class _TentangPageState extends State<TentangPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red.shade800,
        title: Center(
          child: Text('Tentang'),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Text(
                    'Youzitsu Guess',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    '1.0.0',
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Youzitsu Guess adalah game yang menguji kemampuan otak kamu untuk menebak arti gambar.',
            ),
            SizedBox(
              height: 25,
            ),
            Text(
              'Pembuat :',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Rizatzmi'),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                showLicensePage(
                  context: context,
                );
              },
              child: Text("License"),
            ),
          ],
        ),
      ),
    );
  }
}
