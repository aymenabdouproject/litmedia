import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  final Color bgColor;
  final String image;
  final String title, subtitle, description;

  const OnboardingPage({
    super.key,
    required this.bgColor,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor,
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Spacer(),
          Center(child: Image.asset(image)),
          Spacer(),
          Text(title,
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          SizedBox(height: 10),
          Text(subtitle,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70)),
          SizedBox(height: 20),
          Text(description,
              style: TextStyle(fontSize: 14, color: Colors.white70)),
          Spacer(flex: 2),
        ],
      ),
    );
  }
}
