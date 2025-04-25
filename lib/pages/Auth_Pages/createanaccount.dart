import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:litmedia/pages/Auth_Pages/LoginPage.dart';
import 'package:litmedia/pages/Auth_Pages/PhoneLogin.dart';
import 'package:litmedia/pages/Navigation_Pages/homepage.dart';
import 'package:litmedia/pages/auth/auth_service.dart';
import 'package:litmedia/pages/model/user.dart';
import 'package:litmedia/pages/wrapper.dart';
import 'package:litmedia/shared/loading.dart';
import 'package:litmedia/static/colors.dart';
import 'package:litmedia/widget/MyButtons.dart';
import 'package:litmedia/widget/navigationbar.dart';
import 'package:litmedia/widget/textfieldcreate.dart';

class Createanaccount extends StatefulWidget {
  const Createanaccount({super.key});

  @override
  State<Createanaccount> createState() => _CreateanaccountState();
}

class _CreateanaccountState extends State<Createanaccount> {
  bool _obscureText1 = false;
  bool _obscureText2 = false;
  // ignore: prefer_final_fields
  bool _obscureText3 = false;
  final _formkey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  String email = '';
  String password = '';
  String error = '';
  String name = '';
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return _isLoading
        ? Loading()
        : Scaffold(
            backgroundColor: AppColors.offWhite,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.03),
                    decoration: BoxDecoration(
                      color: AppColors.lightPurple,
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width * 0.05),
                    ),
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height *
                          0.1, // Responsive top margin
                      right: MediaQuery.of(context).size.width *
                          0.08, // Responsive right margin
                      left: MediaQuery.of(context).size.width * 0.08,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Create an account",
                          style: TextStyle(
                            fontFamily: "RozhaOne",
                            fontSize: MediaQuery.of(context).size.width * 0.08,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Form(
                          key: _formkey,
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 20, top: 20),
                                child: Textfieldcreate(
                                  obscureText: _obscureText3,
                                  text1: "username",
                                  text2: "enter your username",
                                  prefix: Icon(Icons.person),
                                  suffix: Icon(null),
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return 'The name should not be null';
                                    } else if (val.length < 3) {
                                      return 'Username must be at least 3 characters long';
                                    } else if (!RegExp(r'^[a-zA-Z0-9_]+$')
                                        .hasMatch(val)) {
                                      return 'Username can only contain letters, numbers, and underscores';
                                    }
                                    return null;
                                  },
                                  onChanged: (val) {
                                    setState(() {
                                      name = val;
                                    });
                                  },
                                  decoration: InputDecoration(),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 20, top: 20),
                                child: Textfieldcreate(
                                  onChanged: (val) {
                                    setState(() {
                                      email = val;
                                    });
                                  },
                                  obscureText: _obscureText3,
                                  suffix: Icon(null),
                                  text1: "email",
                                  text2: "enter your email",
                                  prefix: Icon(Icons.email),
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return 'Enter an email please';
                                    } else if (!RegExp(
                                      r'^[^@]+@[^@]+\.[^@]+',
                                    ).hasMatch(val)) {
                                      return 'Enter a valid email';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 20, top: 20),
                                child: Textfieldcreate(
                                  onChanged: (val) {
                                    setState(() {
                                      password = val;
                                    });
                                  },
                                  obscureText: !_obscureText1,
                                  suffix: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _obscureText1 = !_obscureText1;
                                      });
                                    },
                                    child: _obscureText1
                                        ? Icon(Icons.visibility_outlined)
                                        : Icon(Icons.visibility_off_outlined),
                                  ),
                                  text1: "password",
                                  text2: "enter your password",
                                  prefix: Icon(Icons.lock),
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return 'Enter a password please';
                                    } else if (val.length < 6) {
                                      return 'Password must be at least 6 characters long';
                                    } else if (!RegExp(
                                      r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$',
                                    ).hasMatch(val)) {
                                      return 'Password must contain at least one letter and one number';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 20, top: 20),
                                child: Textfieldcreate(
                                  validator: (String? val) {
                                    if (val == null || val.isEmpty) {
                                      return 'Please confirm your password';
                                    } else if (val != password) {
                                      return 'Passwords do not match';
                                    }
                                    return null;
                                  },
                                  obscureText: !_obscureText2,
                                  suffix: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _obscureText2 = !_obscureText2;
                                      });
                                    },
                                    child: _obscureText2
                                        ? Icon(Icons.visibility_outlined)
                                        : Icon(Icons.visibility_off_outlined),
                                  ),
                                  text1: "confirm your password",
                                  text2: "enter your password",
                                  prefix: Icon(Icons.lock),
                                  decoration: InputDecoration(),
                                  //*** some validator code here  */
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: 50,
                                  vertical: 20,
                                ),
                                child: MyElevatedButton(
                                  buttonLabel: "Sign up",
                                  onPressedFct: () async {
                                    if (_formkey.currentState!.validate()) {
                                      setState(() =>
                                          _isLoading = true); // Start loading

                                      try {
                                        // Check if username exists
                                        bool isUnique = false;
                                        try {
                                          isUnique = await _auth
                                              .isUsernameUnique(name);
                                        } catch (e) {
                                          setState(() {
                                            error =
                                                "An error occurred while checking username uniqueness.";
                                            _isLoading = false; // Stop loading
                                          });
                                          return;
                                        }

                                        if (!isUnique) {
                                          setState(() {
                                            error =
                                                "Username already exists. Please choose another.";
                                            _isLoading = false; // Stop loading
                                          });
                                          return; // Stop the signup process if username is not unique
                                        }

                                        // Attempt to sign up the user
                                        CustomUser? result = await _auth
                                            .signUpWithEmailAndPassword(
                                                name, email, password);
                                        if (result == null) {
                                          setState(() {
                                            error = 'Email already in use';
                                            _isLoading = false; // Stop loading
                                          });
                                        } else {
                                          // Save user data to Firestore
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(result.uid)
                                              .set({
                                            'username': name,
                                            'email': result.email,
                                            'createdAt':
                                                FieldValue.serverTimestamp(),
                                          });

                                          // Navigate to the homepage
                                          setState(() => _isLoading =
                                              false); // Stop loading before navigation
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  Navigationbar(),
                                            ),
                                          );
                                        }
                                      } catch (e) {
                                        setState(() {
                                          error = "An error occurred: $e";
                                          _isLoading = false; // Stop loading
                                        });
                                      }
                                    }
                                  },
                                  color1: AppColors.vibrantBlue,
                                  color2: AppColors.offWhite,
                                  color3: Colors.black,
                                ),
                              ),
                              SizedBox(height: 12.0),
                              Text(
                                error,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14.0,
                                ),
                              ),
                              Text("or"),
                              Container(
                                margin: EdgeInsets.only(top: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        try {
                                          final userG =
                                              await _auth.SignupWithGoogle();
                                          if (userG != null) {
                                            print(
                                                "User signed up successfully!");
                                            // Navigate to setup profile page
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      "This email is already in use. Please log in instead.")),
                                            );
                                          }
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    "An error occurred: $e")),
                                          );
                                        }
                                      },
                                      child: Image.asset("images/google.png"),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Phonelogin(),
                                          ),
                                        );
                                      },
                                      child:
                                          Image.asset("images/telephone.png"),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
                                    builder: (context) => Loginpage(),
                                  ),
                                );
                              },
                              color1: AppColors.vibrantBlue,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 40),
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Text(
                            "by creating an account or signing you agree to the",
                          ),
                          Textt(
                            text1: "Terms and Condition",
                            onPressedFct: () {},
                            color1: AppColors.electricPurple,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
