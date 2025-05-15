import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:litmedia/pages/wrapper.dart';
import 'package:litmedia/static/colors.dart';
import 'package:litmedia/pages/model/user.dart';

class AppDrawer extends StatelessWidget {
  final CustomUser? user;
  final List<Map<String, dynamic>> menuItems;

  const AppDrawer({
    super.key,
    required this.user,
    required this.menuItems,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Drawer(
      backgroundColor: AppColors.darkPurple,
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            height: screenHeight * 0.25,
            width: double.infinity,
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  decoration: BoxDecoration(
                    color: AppColors.grayPurple,
                    borderRadius: BorderRadius.circular(screenWidth * 0.2),
                  ),
                  height: screenWidth * 0.2,
                  width: screenWidth * 0.2,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      user?.username ?? '',
                      style: TextStyle(color: AppColors.offWhite),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                        padding: MaterialStateProperty.all(EdgeInsets.zero),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {},
                      child: Text("more details"),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(
                    menuItems[index]['icon'],
                    color: AppColors.offWhite,
                  ),
                  title: Text(
                    menuItems[index]['name'],
                    style: TextStyle(color: AppColors.offWhite),
                  ),
                  onTap: () async {
                    final destination = menuItems[index]["navigate"];
                    if (destination == 'logout') {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => wrapper()),
                      );
                    } else if (destination is Widget) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => destination),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
