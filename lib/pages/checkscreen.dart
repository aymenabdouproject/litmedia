import 'package:flutter/material.dart';
import 'package:litmedia/pages/LoginPage.dart';
import 'package:litmedia/pages/createanaccount.dart';
import 'package:litmedia/static/colors.dart';
import 'package:litmedia/widget/MyButtons.dart';

class Checkscreen extends StatelessWidget {
  const Checkscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.offWhite,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 447,
              width: 447,
              decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage("images/logo.png"))),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 50),
              height: 45,
              width: 301,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/textlogo.png"))),
            ),
            Text("Ready to Transform Your Reading Journey?"),
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      top: 100, right: 50, left: 50, bottom: 10),
                  child: MyElevatedButton(
                      color3: AppColors.vibrantBlue,
                      buttonLabel: 'sign in',
                      onPressedFct: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Loginpage()));
                      },
                      color1: AppColors.vibrantBlue,
                      color2: Colors.white),
                ),
                Container(
                  margin: EdgeInsets.only(right: 50, left: 50),
                  child: MyElevatedButton(
                      color3: Colors.black,
                      buttonLabel: 'create an account',
                      onPressedFct: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Createanaccount()));
                      },
                      color1: AppColors.greywhite,
                      color2: Colors.black),
                ),
              ],
            )
          ],
        ));
  }
}
