import 'package:flutter/material.dart';
import 'package:litmedia/pages/checkscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LitMedia',
      theme: ThemeData(fontFamily: "RocknRollOne"),
      debugShowCheckedModeBanner: false,
      home: Checkscreen(),
    );
  }
}
