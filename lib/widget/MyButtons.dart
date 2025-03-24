import 'package:flutter/material.dart';

class MyElevatedButton extends StatelessWidget {
  final String buttonLabel;
  final Function() onPressedFct;
  final Color color1;
  final Color color2;
  final Color color3;
  MyElevatedButton(
      {required this.buttonLabel,
      required this.onPressedFct,
      super.key,
      required this.color1,
      required this.color2,
      required this.color3});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 50,
        width: double.maxFinite,
        child: ElevatedButton(
          onPressed: onPressedFct,
          child: Text(
            buttonLabel,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color2,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: color1,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(color: color3)),
          ),
        ));
  }
}

class MynewButtoms extends StatelessWidget {
  final String buttonLabel;
  final Function() onPressedFct;

  MynewButtoms({
    super.key,
    required this.buttonLabel,
    required this.onPressedFct,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
          ),
          onPressed: onPressedFct,
          child: Row(
            children: [
              CircleAvatar(),
              Text(
                buttonLabel,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          )),
    );
  }
}

class Textt extends StatelessWidget {
  final String text1;
  final Function() onPressedFct;
  final Color color1;
  Textt(
      {super.key,
      required this.text1,
      required this.onPressedFct,
      required this.color1});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressedFct,
      child: Text(
        text1,
        style:
            TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color1),
      ),
    );
  }
}
