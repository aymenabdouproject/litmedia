import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF242038), // Corrected color value
      child: Center(
        child: SpinKitPouringHourGlass(
          color: const Color(0xFF7C3AED), // Corrected color value
          size: 50.0,
        ),
      ),
    );
  }
}
