import 'package:flutter/material.dart';
import 'package:litmedia/static/colors.dart';

class Info extends StatelessWidget {
  final String text;
  final String title;
  final String image1;
  const Info(
      {super.key,
      required this.text,
      required this.image1,
      required this.title});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.18,
      width: screenWidth * 0.9,
      decoration: BoxDecoration(
          color: Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
                top: screenHeight * 0.01, right: screenWidth * 0.6),
            child: Image.asset(
              image1,
              width: screenWidth * 0.15,
              height: screenHeight * 0.05,
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                top: screenHeight * 0.01, right: screenWidth * 0.5),
            child: Text(
              title,
              style: TextStyle(
                  fontSize: screenWidth * 0.045, color: AppColors.gris),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05, // Responsive horizontal margin
              vertical: screenHeight * 0.01, // Responsive vertical margin
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: screenWidth * 0.035, // Responsive font size
                color: AppColors.gris.withOpacity(0.49),
              ),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}
