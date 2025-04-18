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
    return Container(
      height: 137.04,
      width: 358,
      decoration: BoxDecoration(
          color: Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 5, right: 250),
            child: Image.asset(
              image1,
              width: 53,
              height: 39,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, right: 220),
            child: Text(
              title,
              style: TextStyle(fontSize: 16, color: AppColors.gris),
            ),
          ),
          Container(
              margin: EdgeInsets.all(10),
              child: Text(text,
                  style: TextStyle(
                    color: AppColors.gris.withOpacity(0.49),
                  )))
        ],
      ),
    );
  }
}
