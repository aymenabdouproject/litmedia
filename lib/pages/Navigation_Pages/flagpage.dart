import 'package:flutter/material.dart';
import 'package:litmedia/static/colors.dart';

class Flagpage extends StatelessWidget {
  const Flagpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: Center(child: Text("Flag Page", style: TextStyle(fontSize: 24))),
    );
  }
}
