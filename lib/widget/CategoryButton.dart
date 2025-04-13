import 'package:flutter/material.dart';

class Categorybutton extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  const Categorybutton(
      {super.key, required this.label, required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        height: 61,
        width: 109,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'YourCustomFont',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
