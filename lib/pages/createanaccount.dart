import 'package:flutter/material.dart';
import 'package:litmedia/pages/LoginPage.dart';
import 'package:litmedia/pages/PhoneLogin.dart';
import 'package:litmedia/static/colors.dart';
import 'package:litmedia/widget/MyButtons.dart';
import 'package:litmedia/widget/textfieldcreate.dart';

class Createanaccount extends StatefulWidget {
  const Createanaccount({super.key});

  @override
  State<Createanaccount> createState() => _CreateanaccountState();
}

class _CreateanaccountState extends State<Createanaccount> {
  bool _obscureText1 = false;
  bool _obscureText2 = false;
  bool _obscureText3 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.offWhite,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.maxFinite,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: AppColors.lightPurple,
                    borderRadius: BorderRadius.circular(30)),
                margin: EdgeInsets.only(
                  top: 80,
                  right: 30,
                  left: 30,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Create an account",
                      style: TextStyle(
                        fontFamily: "RozhaOne",
                        fontSize: 37,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                            margin: EdgeInsets.only(bottom: 20, top: 20),
                            child: Textfieldcreate(
                              obscureText: _obscureText3,
                              text1: "username",
                              text2: "your username",
                              prefix: Icon(null),
                              suffix: Icon(null),
                            )),
                        Container(
                            margin: EdgeInsets.only(bottom: 20, top: 20),
                            child: Textfieldcreate(
                              obscureText: _obscureText3,
                              suffix: Icon(null),
                              text1: "email",
                              text2: "your email",
                              prefix: Icon(null),
                            )),
                        Container(
                            margin: EdgeInsets.only(bottom: 20, top: 20),
                            child: Textfieldcreate(
                              obscureText: _obscureText1,
                              suffix: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _obscureText1 = !_obscureText1;
                                    });
                                  },
                                  child: _obscureText1
                                      ? Icon(Icons.visibility_off_outlined)
                                      : Icon(Icons.visibility_outlined)),
                              text1: "password",
                              text2: "password",
                              prefix: Icon(null),
                            )),
                        Container(
                          margin: EdgeInsets.only(bottom: 20, top: 20),
                          child: Textfieldcreate(
                            obscureText: _obscureText2,
                            suffix: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obscureText2 = !_obscureText2;
                                  });
                                },
                                child: _obscureText2
                                    ? Icon(Icons.visibility_off_outlined)
                                    : Icon(Icons.visibility_outlined)),
                            text1: "confirm your password",
                            text2: "password",
                            prefix: Icon(null),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                          child: MyElevatedButton(
                              buttonLabel: "Sign up",
                              onPressedFct: () {},
                              color1: AppColors.vibrantBlue,
                              color2: AppColors.offWhite,
                              color3: Colors.black),
                        ),
                        Text("or"),
                        Container(
                          margin: EdgeInsets.only(
                            top: 20,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: Image.asset("images/google.png"),
                              ),
                              GestureDetector(
                                  onTap: () {},
                                  child: Image.asset("images/facebook.png")),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Phonelogin()));
                                  },
                                  child: Image.asset("images/telephone.png")),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("already have an account ?"),
                        Textt(
                            text1: "Login",
                            onPressedFct: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Loginpage()));
                            },
                            color1: AppColors.vibrantBlue)
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: 40,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Column(children: [
                    Text(
                      "by creating an account or signing you agree to the",
                    ),
                    Textt(
                        text1: "Terms and Condition",
                        onPressedFct: () {},
                        color1: AppColors.electricPurple)
                  ]),
                ),
              ),
            ],
          ),
        ));
  }
}
