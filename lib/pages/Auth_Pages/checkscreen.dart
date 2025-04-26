import 'package:flutter/material.dart';
import 'package:litmedia/pages/Auth_Pages/LoginPage.dart';
import 'package:litmedia/pages/Auth_Pages/createanaccount.dart';
import 'package:litmedia/static/colors.dart';
import 'package:litmedia/widget/MyButtons.dart';

class Checkscreen extends StatelessWidget {
  const Checkscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.04),
                SizedBox(
                  height: constraints.maxHeight * 0.35,
                  child: Center(
                    child: Image.asset(
                      'images/logo.png',
                      height: screenHeight *
                          0.2, // Adjust height based on screen size
                      width: screenHeight *
                          0.2, // Adjust width based on screen size
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  height: screenHeight * 0.05,
                  width: screenWidth * 0.8,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/textlogo.png"),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.06),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: Text(
                    "Ready to Transform Your Reading Journey?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth * 0.045, // Responsive font size
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.09),
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.1,
                        vertical: screenHeight * 0.02,
                      ),
                      child: MyElevatedButton(
                        color3: AppColors.vibrantBlue,
                        buttonLabel: 'sign in',
                        onPressedFct: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Loginpage()),
                          );
                        },
                        color1: AppColors.vibrantBlue,
                        color2: Colors.white,
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                      child: MyElevatedButton(
                        color3: Colors.black,
                        buttonLabel: 'create an account',
                        onPressedFct: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Createanaccount(),
                            ),
                          );
                        },
                        color1: AppColors.greywhite,
                        color2: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
