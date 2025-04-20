import 'package:flutter/material.dart';
import 'package:litmedia/static/colors.dart';

class Savepage extends StatelessWidget {
  const Savepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.offWhite,
      body:  Center(child: Text("Save Page", style: TextStyle(fontSize: 24))),
    );
  }
}
