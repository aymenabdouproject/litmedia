import 'package:flutter/material.dart';
import 'package:litmedia/pages/Auth_Pages/phoneverify.dart';
import 'package:litmedia/static/colors.dart';
import 'package:litmedia/widget/MyButtons.dart';
import 'package:litmedia/widget/textfieldcreate.dart';

class Phonelogin extends StatelessWidget {
  const Phonelogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.offWhite,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios)),
      ),
      backgroundColor: AppColors.offWhite,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "enter your phone number",
            style: TextStyle(fontSize: 24),
          ),
          Column(
            children: [
              Container(
                  margin: EdgeInsets.all(40),
                  child: Textfieldcreate(
                    obscureText: true,
                    suffix: Icon(null),
                    text1: "",
                    text2: "",
                    prefix: Icon(null),
                  )),
              Container(
                margin: EdgeInsets.all(70),
                child: MyElevatedButton(
                  buttonLabel: "Done",
                  onPressedFct: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Phoneverify()));
                  },
                  color1: AppColors.vibrantBlue,
                  color2: AppColors.offWhite,
                  color3: Colors.black,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
