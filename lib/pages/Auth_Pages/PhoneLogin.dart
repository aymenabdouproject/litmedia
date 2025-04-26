import 'package:flutter/material.dart';

// ignore: library_prefixes
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart'
    // ignore: library_prefixes
    as FlutterLibphonenumber;
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:litmedia/pages/Auth_Pages/phoneverify.dart';
import 'package:litmedia/pages/auth/auth_service.dart';
import 'package:litmedia/shared/loading.dart';
import 'package:litmedia/static/colors.dart';
import 'package:litmedia/widget/MyButtons.dart';

class Phonelogin extends StatefulWidget {
  const Phonelogin({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PhoneloginState createState() => _PhoneloginState();
}

class _PhoneloginState extends State<Phonelogin> {
  final TextEditingController _controller = TextEditingController();
  PhoneNumber _number = PhoneNumber(isoCode: 'DZ');
  String _phoneNumber = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializePhoneNumber();
  }

  void _initializePhoneNumber() async {
    await FlutterLibphonenumber.init();
  }

  void _validatePhoneNumber() {
    if (_phoneNumber.isEmpty) {
      _showMessage("Please enter a valid phone number.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    AuthService().verifyPhoneNumber(
      _phoneNumber,
      (verificationId) {
        setState(() {
          isLoading = false;
        });
        // Navigate to OTP screen and pass the verificationId
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Phoneverify(verificationId: verificationId),
          ),
        );
      },
      (message) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      },
      (error) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error)));
      },
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

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
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.05),
                    Text(
                      "Enter your phone number",
                      style: TextStyle(
                        fontSize: screenWidth * 0.06, // Responsive font size
                        fontFamily: "Rozha One",
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    InternationalPhoneNumberInput(
                      onInputChanged: (PhoneNumber number) {
                        setState(() {
                          _number = number;
                          _phoneNumber = number.phoneNumber ?? "";
                        });
                      },
                      selectorConfig: SelectorConfig(
                        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                      ),
                      ignoreBlank: false,
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      initialValue: _number,
                      textFieldController: _controller,
                      formatInput: true,
                      keyboardType: TextInputType.phone,
                      inputBorder: OutlineInputBorder(),
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    MyElevatedButton(
                      buttonLabel: "Done",
                      onPressedFct: () {
                        _validatePhoneNumber();
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
          );
  }
}
