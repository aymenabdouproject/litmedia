import 'package:flutter/material.dart';
import 'package:litmedia/static/colors.dart';
import 'package:litmedia/widget/MyButtons.dart';

class Phoneverify extends StatelessWidget {
  const Phoneverify({super.key, required String verificationId});

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
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "Check Your Phone",
              style: TextStyle(
                fontSize: 24,
              ),
            ),
          ),
          Container(
            child: Text("we've send a code to your phone ",
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.gris.withOpacity(0.49),
                )),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return OTPInputField(
                  isLast: index == 4,
                );
              }),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              "code expires in : ",
              style: TextStyle(
                fontSize: 16,
                color: AppColors.gris.withOpacity(0.49),
              ),
            ),
          ),
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10, right: 70, left: 70),
                child: MyElevatedButton(
                    buttonLabel: "Verify",
                    onPressedFct: () {},
                    color1: AppColors.vibrantBlue,
                    color2: AppColors.offWhite,
                    color3: Colors.black),
              ),
              Container(
                margin: EdgeInsets.only(top: 10, right: 70, left: 70),
                child: MyElevatedButton(
                    buttonLabel: "send again",
                    onPressedFct: () {},
                    color1: AppColors.greywhite,
                    color2: Colors.black,
                    color3: Colors.black),
              )
            ],
          )
        ],
      ),
    );
  }
}

class OTPInputField extends StatelessWidget {
  final bool isLast;

  OTPInputField({
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      width: 81,
      height: 81,
      child: TextField(
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: "",
          hintText: "-",
          hintStyle: TextStyle(color: AppColors.grayPurple),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(27),
            borderSide: BorderSide(
                color: isLast ? AppColors.vibrantBlue : Colors.grey, width: 1),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(27),
            borderSide: BorderSide(
                color: isLast ? AppColors.vibrantBlue : Colors.grey, width: 2),
          ),
          filled: !isLast,
          fillColor: isLast ? Colors.transparent : Color(0xFFF2EAE1),
        ),
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
