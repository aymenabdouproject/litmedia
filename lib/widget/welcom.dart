import 'package:flutter/material.dart';

class Welcom extends StatelessWidget {
  final VoidCallback onDismiss;
  final String title;
  final String text;
  const Welcom({
    super.key,
    required this.onDismiss,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            text,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(text),
          ElevatedButton(
            onPressed: onDismiss,
            child: Text("OK"),
            style: ElevatedButton.styleFrom(
                minimumSize: Size(100, 40),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
          )
        ],
      ),
    );
  }
}
