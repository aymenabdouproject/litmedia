import 'package:flutter/material.dart';
import 'package:litmedia/pages/AdminPanel/adminNavWidget.dart';
import 'package:litmedia/pages/Auth_Pages/checkscreen.dart';
import 'package:litmedia/pages/model/user.dart';
import 'package:litmedia/widget/navigationbar.dart';
import 'package:provider/provider.dart'; // <-- Import your admin page

class wrapper extends StatelessWidget {
  const wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);
    print("Logged in user: $user");

    if (user == null) {
      return Checkscreen(); // not logged in
    } else if (user.email == 'admin@example.com') {
      return NavigationbarAdmin(); // route for admin
    } else {
      return Navigationbar(
        uploadedMediaUrls: {},
      ); // regular user
    }
  }
}
