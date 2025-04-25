import 'package:flutter/material.dart';

class ForYouSection extends StatelessWidget {
  final String title;
  final String likes;
  final double rating;
  const ForYouSection(
      {super.key,
      required this.title,
      required this.likes,
      required this.rating});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: screenWidth * 0.6,
      height: screenHeight * 0.2,
      padding: EdgeInsets.all(screenWidth * 0.04),
      margin: EdgeInsets.only(right: screenWidth * 0.04),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(screenWidth * 0.08)),
      child: Row(
        children: [
          SizedBox(
            width: screenWidth * 0.04,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold),
                maxLines: 2,
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Row(
                children: [
                  Text(
                    rating.toString(),
                    style: TextStyle(
                        fontSize: screenWidth * 0.035, color: Colors.grey),
                  ),
                  SizedBox(
                    width: screenWidth * 0.03,
                  ),
                  Container(
                    padding: EdgeInsetsDirectional.symmetric(
                        horizontal: screenWidth * 0.03,
                        vertical: screenHeight * 0.01),
                    decoration: BoxDecoration(
                        color: Color(0xFFD9CFFF),
                        borderRadius:
                            BorderRadius.circular(screenWidth * 0.05)),
                    child: Text(
                      likes,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                          fontSize: screenWidth * 0.035),
                    ),
                  )
                ],
              )
            ],
          ))
        ],
      ),
    );
  }
}
