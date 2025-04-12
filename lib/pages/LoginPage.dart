import 'package:flutter/material.dart';
import 'package:litmedia/pages/forgetpass.dart';
import 'package:litmedia/pages/homepage.dart';
import 'package:litmedia/static/colors.dart';
import 'package:litmedia/widget/MyButtons.dart';
import 'package:litmedia/widget/textfieldcreate.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  bool _obscureText = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              alignment: Alignment.center,
              child: Image.asset('images/logo.png'),
            ),
            Container(
                height: MediaQuery.of(context).size.height * 0.6,
                padding: EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                    color: AppColors.lightPurple,
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(56))),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      child: Text(
                        "Log In",
                        style: TextStyle(
                          fontFamily: "RozhaOne",
                          fontSize: 37,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 100, bottom: 20),
                          child: Textfieldcreate(
                            obscureText: false,
                            suffix: Icon(null),
                            text1: "username",
                            text2: "your username",
                            prefix: Icon(null),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Textfieldcreate(
                              obscureText: _obscureText,
                              suffix: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                  child: _obscureText
                                      ? Icon(Icons.visibility_off_outlined)
                                      : Icon(Icons.visibility_outlined)),
                              text1: "password",
                              text2: "your password",
                              prefix: Icon(null),
                            ),
                            Textt(
                                text1: "Forget your password",
                                onPressedFct: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Forgetpass()));
                                },
                                color1: AppColors.vibrantBlue),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                          child: MyElevatedButton(
                              buttonLabel: "Log in",
                              onPressedFct: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Homepage()));
                              },
                              color1: AppColors.vibrantBlue,
                              color2: Colors.white,
                              color3: Colors.black),
                        )
                      ],
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
