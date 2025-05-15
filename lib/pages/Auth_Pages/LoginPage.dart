import 'package:flutter/material.dart';
import 'package:litmedia/pages/Auth_Pages/PhoneLogin.dart';
import 'package:litmedia/pages/Auth_Pages/createanaccount.dart';
import 'package:litmedia/pages/Auth_Pages/forgetpass.dart';
import 'package:litmedia/pages/Navigation_Pages/homepage.dart';
import 'package:litmedia/pages/auth/auth_service.dart';
import 'package:litmedia/shared/loading.dart';
import 'package:litmedia/static/colors.dart';
import 'package:litmedia/widget/MyButtons.dart';
import 'package:litmedia/widget/navigationbar.dart';
import 'package:litmedia/widget/textfieldcreate.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String email = '';
  String password = '';
  String error = '';
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return _isLoading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false, // Prevents bottom overflow issues
            backgroundColor: AppColors.offWhite,
            body: SafeArea(
              child: Column(
                children: [
                  /// Logo Section
                  Container(
                    height: screenHeight * 0.3,
                    alignment: Alignment.center,
                    child: Image.asset(
                      'images/logo.png',
                      height: screenHeight * 0.18, // Responsive height
                      width: screenHeight * 0.18, // Responsive width
                      fit: BoxFit.contain,
                    ),
                  ),

                  /// Login Form Section
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.only(
                        left: screenWidth * 0.05,
                        right: screenWidth * 0.05,
                        bottom: MediaQuery.of(context)
                            .viewInsets
                            .bottom, // Adjust for keyboard
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.lightPurple,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(56),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: screenHeight * 0.05),

                            /// Title
                            Center(
                              child: Text(
                                "Log In",
                                style: TextStyle(
                                  fontFamily: "RozhaOne",
                                  fontSize: screenWidth *
                                      0.08, // Responsive font size
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.03),

                            /// Login Form
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  /// Email Field
                                  Textfieldcreate(
                                    onChanged: (val) {
                                      setState(() => email = val);
                                    },
                                    obscureText: false,
                                    suffix: Icon(null),
                                    text1: "Email",
                                    text2: "Enter your email",
                                    prefix: Icon(Icons.email),
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return 'Enter an email please';
                                      }
                                      if (!RegExp(
                                        r'^[^@]+@[^@]+\.[^@]+',
                                      ).hasMatch(val)) {
                                        return 'Enter a valid email';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(),
                                  ),

                                  SizedBox(height: screenHeight * 0.02),

                                  /// Password Field
                                  Textfieldcreate(
                                    onChanged: (val) {
                                      setState(() => password = val);
                                    },
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return 'Enter a password please';
                                      }
                                      if (val.length < 6) {
                                        return 'Password must be at least 6 characters long';
                                      }
                                      if (!RegExp(
                                        r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$',
                                      ).hasMatch(val)) {
                                        return 'Password must contain at least one letter and one number';
                                      }
                                      return null;
                                    },
                                    obscureText: _obscureText,
                                    suffix: GestureDetector(
                                      onTap: () {
                                        setState(
                                          () => _obscureText = !_obscureText,
                                        );
                                      },
                                      child: Icon(_obscureText
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined),
                                    ),
                                    text1: "Password",
                                    text2: "Enter your password",
                                    prefix: Icon(Icons.lock),
                                    decoration: InputDecoration(),
                                  ),

                                  SizedBox(height: screenHeight * 0.01),

                                  /// Forgot Password Button
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Forgetpass(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "Forgot your password?",
                                        style: TextStyle(
                                          color: AppColors.vibrantBlue,
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: screenHeight * 0.02),

                                  /// Login Button
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 50,
                                      vertical: 20,
                                    ),
                                    child: MyElevatedButton(
                                      buttonLabel: "Log in",
                                      onPressedFct: () async {
                                        if (_formKey.currentState!.validate()) {
                                          setState(() => _isLoading = true);
                                          try {
                                            dynamic result = await _auth
                                                .signInWithEmailPassword(
                                              email,
                                              password,
                                            );
                                            if (result == null) {
                                              setState(() {
                                                error =
                                                    'Could not sign in with those credentials';
                                                _isLoading = false;
                                              });
                                            } else {
                                              setState(
                                                  () => _isLoading = false);
                                              Navigator.pushReplacement(
                                                // ignore: use_build_context_synchronously
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      Navigationbar(
                                                    uploadedMediaUrls: {},
                                                  ),
                                                ),
                                              );
                                            }
                                          } catch (e) {
                                            setState(() {
                                              error = e.toString();
                                              _isLoading = false;
                                            });
                                          }
                                        }
                                      },
                                      color1: AppColors.vibrantBlue,
                                      color2: Colors.white,
                                      color3: Colors.black,
                                    ),
                                  ),

                                  SizedBox(height: screenHeight * 0.02),

                                  /// Error Message Display
                                  if (error.isNotEmpty)
                                    Text(
                                      error,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: screenWidth * 0.04,
                                      ),
                                    ),

                                  SizedBox(height: screenHeight * 0.02),

                                  /// Social Login
                                  Center(child: Text("or")),

                                  SizedBox(height: screenHeight * 0.02),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      /// Google Login
                                      GestureDetector(
                                        onTap: () async {
                                          dynamic userG =
                                              await _auth.loginWithGoogle();
                                          if (userG != null) {
                                            Navigator.pushReplacement(
                                              // ignore: use_build_context_synchronously
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    Homepage(),
                                              ),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(
                                              // ignore: use_build_context_synchronously
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  "Google login failed. Please try again.",
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        child: Image.asset(
                                          "images/google.png",
                                          width: screenWidth * 0.1,
                                        ),
                                      ),

                                      /// Phone Login
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  Phonelogin(),
                                            ),
                                          );
                                        },
                                        child: Image.asset(
                                          "images/telephone.png",
                                          width: screenWidth * 0.1,
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: screenHeight * 0.03),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Don't have an account yet?"),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  Createanaccount(),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "Sign up",
                                          style: TextStyle(
                                            color: AppColors.vibrantBlue,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
