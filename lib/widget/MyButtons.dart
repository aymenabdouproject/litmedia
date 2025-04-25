import 'package:flutter/material.dart';

class MyElevatedButton extends StatelessWidget {
  final String buttonLabel;
  final Function() onPressedFct;
  final Color color1;
  final Color color2;
  final Color color3;
  const MyElevatedButton({
    required this.buttonLabel,
    required this.onPressedFct,
    super.key,
    required this.color1,
    required this.color2,
    required this.color3,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.07,
      width: double.maxFinite,
      child: ElevatedButton(
        onPressed: onPressedFct,
        style: ElevatedButton.styleFrom(
          backgroundColor: color1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screenWidth * 0.04),
            side: BorderSide(color: color3),
          ),
        ),
        child: Text(
          buttonLabel,
          style: TextStyle(
            fontSize: screenWidth * 0.05,
            fontWeight: FontWeight.bold,
            color: color2,
          ),
        ),
      ),
    );
  }
}

class MynewButtoms extends StatelessWidget {
  final String buttonLabel;
  final Function() onPressedFct;

  const MynewButtoms({
    super.key,
    required this.buttonLabel,
    required this.onPressedFct,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.07,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
        onPressed: onPressedFct,
        child: Row(
          children: [
            CircleAvatar(
              radius: screenWidth * 0.05,
            ),
            SizedBox(width: screenWidth * 0.03),
            Text(buttonLabel,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.045,
                )),
          ],
        ),
      ),
    );
  }
}

class Textt extends StatelessWidget {
  final String text1;
  final Function() onPressedFct;
  final Color color1;
  const Textt({
    super.key,
    required this.text1,
    required this.onPressedFct,
    required this.color1,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return TextButton(
      onPressed: onPressedFct,
      child: Text(
        text1,
        style: TextStyle(
          fontSize: screenWidth * 0.035,
          fontWeight: FontWeight.bold,
          color: color1,
        ),
      ),
    );
  }
}
