import 'package:flutter/material.dart';
import 'package:litmedia/static/colors.dart';

class Playpage extends StatelessWidget {
  const Playpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
        body:  Center(child: Text("Play Page", style: TextStyle(fontSize: 24))),
    );
  }
}
