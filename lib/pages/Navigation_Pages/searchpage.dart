import 'package:flutter/material.dart';
import 'package:litmedia/static/colors.dart';

class Searchpage extends StatelessWidget {
  const Searchpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: Center(child: Text("Search Page", style: TextStyle(fontSize: 24))),
    );
  }
}
