import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:litmedia/pages/Navigation_Pages/flagpage.dart';
import 'package:litmedia/pages/Navigation_Pages/homepage.dart';
import 'package:litmedia/pages/Navigation_Pages/playpage.dart';
import 'package:litmedia/pages/Navigation_Pages/savepage.dart';
import 'package:litmedia/pages/Navigation_Pages/searchpage.dart';
import 'package:litmedia/pages/menuPages/createContent.dart';
import 'package:litmedia/pages/model/multimedia.dart';
import 'package:litmedia/static/colors.dart';

class Navigationbar extends StatefulWidget {
  final Map<MediaType, String?> uploadedMediaUrls; // Made non-nullable

  const Navigationbar({
    super.key,
    required this.uploadedMediaUrls,
  });

  @override
  State<Navigationbar> createState() => _NavigationbarState();
}

class _NavigationbarState extends State<Navigationbar> {
  int selectedIndex = 0;
  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    // Initialize pages with the required media URLs and quotes
    pages = [
      Homepage(),
      Searchpage(),
      Mediapage(uploadedMediaUrls: widget.uploadedMediaUrls),
      Flagpage(),
      Savepage(),
    ];
  }

  final List<IconData> icons = [
    Icons.home,
    Icons.search,
    Icons.play_circle_fill_outlined,
    Icons.flag,
    Icons.save,
  ];

  final List<String> nameindex = [
    "Home",
    "Search",
    "Play",
    "Flag",
    "Save",
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: pages[selectedIndex],
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.009),
        decoration: BoxDecoration(
          color: AppColors.purpleclair,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(screenWidth * 0.08),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(pages.length, (index) {
            // Highlight the selected tab
            if (index == selectedIndex) {
              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.03,
                  vertical: screenHeight * 0.01,
                ),
                decoration: BoxDecoration(
                  color: AppColors.offWhite,
                  borderRadius: BorderRadius.circular(screenWidth * 0.05),
                ),
                child: Row(
                  children: [
                    Icon(
                      icons[index],
                      size: screenWidth * 0.05,
                      color: Colors.black,
                    ),
                    SizedBox(width: screenWidth * 0.015),
                    Text(
                      nameindex[index],
                      style: TextStyle(
                        color: AppColors.vibrantBlue,
                        fontSize: screenWidth * 0.035,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return IconButton(
                icon: Icon(
                  icons[index],
                  size: screenWidth * 0.07,
                  color: Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              );
            }
          }),
        ),
      ),
    );
  }
}
