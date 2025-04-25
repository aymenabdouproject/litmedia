import 'package:flutter/material.dart';
import 'package:litmedia/pages/Auth_Pages/checkscreen.dart';
import 'package:litmedia/pages/model/user.dart';
import 'package:litmedia/widget/navigationbar.dart';
import 'package:provider/provider.dart';

class wrapper extends StatelessWidget {
  const wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    //return either Home or Authenticate widget
    final user = Provider.of<CustomUser?>(context);
    print(user);

    // ignore: unnecessary_null_comparison
    if (user == null) {
      return Checkscreen();
    } else {
      return Navigationbar();
    }
  }
}
