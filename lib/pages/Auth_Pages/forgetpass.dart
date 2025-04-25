import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:litmedia/pages/Auth_Pages/LoginPage.dart';
import 'package:litmedia/shared/loading.dart';
import 'package:litmedia/static/colors.dart';
import 'package:litmedia/widget/MyButtons.dart';
import 'package:litmedia/widget/textfieldcreate.dart';

class Forgetpass extends StatefulWidget {
  const Forgetpass({super.key});

  @override
  State<Forgetpass> createState() => _ForgetpassState();
}

class _ForgetpassState extends State<Forgetpass> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return isLoading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.offWhite,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios),
              ),
            ),
            backgroundColor: AppColors.offWhite,
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: screenHeight * 0.05),
                      Text(
                        "Password Recovery",
                        style: TextStyle(
                          fontSize: screenWidth * 0.06, // Responsive font size
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        "Enter your email to recover your password",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth * 0.04, // Responsive font size
                          color: AppColors.gris.withOpacity(0.49),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.05),
                      Textfieldcreate(
                        controller: emailController,
                        obscureText: false,
                        suffix: Icon(null),
                        text1: "Email",
                        text2: "Your email",
                        prefix: Icon(Icons.mail_outline),
                        validator: (String? val) {
                          if (val!.isEmpty) {
                            return 'Enter an email please';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(val)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(),
                      ),
                      SizedBox(height: screenHeight * 0.05),
                      MyElevatedButton(
                        buttonLabel: "Recover your password",
                        onPressedFct: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() => isLoading = true);
                            sendPasswordResetEmail(
                                context, emailController.text);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Loginpage()),
                            );
                          }
                        },
                        color1: AppColors.vibrantBlue,
                        color2: AppColors.offWhite,
                        color3: Colors.black,
                      ),
                      SizedBox(height: screenHeight * 0.05),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}

void sendPasswordResetEmail(BuildContext context, String email) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Password reset link sent to $email")),
    );
  } catch (e) {
    // Handle errors (invalid email, etc.)
    print("Error: $e");
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
  }
}
