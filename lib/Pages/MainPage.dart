import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            "assets/background.png",
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/Logo.png",
                height: MediaQuery.of(context).size.height * 0.4,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(Size(150, 10)),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey[900]),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)))),
                    onPressed: () {
                      Navigator.pushNamed(context, 'Question');
                    },
                    child: Text(
                      'MULAI',
                      style: TextStyle(
                          color: Colors.white, fontStyle: FontStyle.italic),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  TextButton(
                    style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(Size(150, 10)),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey[900]),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)))),
                    onPressed: () {},
                    child: Text(
                      'KIRIM SOAL',
                      style: TextStyle(
                          color: Colors.white, fontStyle: FontStyle.italic),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(Size(150, 10)),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey[900]),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)))),
                    onPressed: () {
                      Navigator.pushNamed(context, 'CaraMain');
                    },
                    child: Text(
                      'CARA MAIN',
                      style: TextStyle(
                          color: Colors.white, fontStyle: FontStyle.italic),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  TextButton(
                    style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(Size(150, 10)),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey[900]),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)))),
                    onPressed: () {
                      Navigator.pushNamed(context, 'Tentang');
                    },
                    child: Text(
                      'TENTANG',
                      style: TextStyle(
                          color: Colors.white, fontStyle: FontStyle.italic),
                    ),
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
