import 'package:flutter/material.dart';

class GameButton extends StatelessWidget {
  GameButton({
    @required this.image,
    @required this.onPress,
    this.hover,
    this.height,
    this.widht,
  });
  final String image;
  final Function onPress;
  final Color hover;
  final double height;
  final double widht;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: widht,
      child: InkWell(
        onTap: onPress,
        splashColor: hover,
        child: Image.asset(image),
      ),
    );
  }
}
