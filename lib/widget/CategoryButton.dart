import 'package:flutter/material.dart';

class Categorybutton extends StatelessWidget {
  final String label;
  final Color backgroundColor;

  const Categorybutton(
      {super.key, required this.label, required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
        height: screenHeight * 0.08,
        width: screenWidth * 0.25,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(screenWidth * 0.04),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Sancreek",
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
