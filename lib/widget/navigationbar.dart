import 'package:flutter/material.dart';
import 'package:litmedia/pages/Navigation_Pages/flagpage.dart';
import 'package:litmedia/pages/Navigation_Pages/homepage.dart';
import 'package:litmedia/pages/Navigation_Pages/playpage.dart';
import 'package:litmedia/pages/Navigation_Pages/savepage.dart';
import 'package:litmedia/pages/Navigation_Pages/searchpage.dart';
import 'package:litmedia/static/colors.dart';

class Navigationbar extends StatefulWidget {
  const Navigationbar({super.key});

  @override
  State<Navigationbar> createState() => _NavigationbarState();
}

class _NavigationbarState extends State<Navigationbar> {
  int selectedIndex = 0;
  final List pages = [
    Homepage(),
    Searchpage(),
    Playpage(),
    Flagpage(),
    Savepage(),
  ];
  final List<IconData> icons = [
    Icons.home,
    Icons.search,
    Icons.play_circle_fill_outlined,
    Icons.flag,
    Icons.save,
  ];
  final List<String> nameindex = [
    "home",
    "Search",
    "play",
    "flag",
    "Save",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: pages[selectedIndex],
      bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.purpleclair,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(pages.length, (index) {
              if (index == selectedIndex) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.offWhite,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(icons[index], size: 20, color: Colors.black),
                      SizedBox(width: 6),
                      Text(nameindex[index],
                          style: TextStyle(color: AppColors.vibrantBlue)),
                    ],
                  ),
                );
              } else {
                return IconButton(
                  icon: Icon(icons[index], size: 28, color: Colors.black),
                  onPressed: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                );
              }
            }),
          )),
    );
  }
}
