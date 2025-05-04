import 'package:flutter/material.dart';
import 'package:litmedia/pages/Navigation_Pages/TabBarMediaPage/Audiopage.dart';
import 'package:litmedia/pages/Navigation_Pages/TabBarMediaPage/Gallerypage.dart';
import 'package:litmedia/pages/Navigation_Pages/TabBarMediaPage/Videopage.dart';
import 'package:litmedia/static/colors.dart';

class Mediapage extends StatefulWidget {
  const Mediapage({super.key});

  @override
  State<Mediapage> createState() => _MediapageState();
}

class _MediapageState extends State<Mediapage> {
  @override
  Widget build(BuildContext context) {
    final screewidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    final List<String> tabLabels = ["GALLERY", "AUDIO", "VIDEO"];
    return DefaultTabController(
      length: tabLabels.length,
      child: Scaffold(
        backgroundColor: Color(0xFFF5EDE5),
        appBar: AppBar(
          backgroundColor: Color(0xFF251B3E),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.menu, size: 28, color: AppColors.offWhite),
              Icon(Icons.notifications, size: 28, color: AppColors.offWhite),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(80),
            child: Container(
              padding: EdgeInsets.all(5),
              height: 70,
              width: screewidth,
              decoration: BoxDecoration(
                  color: AppColors.offWhite,
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(40))),
              child: TabBar(
                isScrollable: true,
                indicator: BoxDecoration(
                  color: AppColors.electricPurple,
                  borderRadius: BorderRadius.circular(12),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                labelStyle: TextStyle(fontWeight: FontWeight.w500),
                tabs: tabLabels
                    .map((label) => Container(
                          width: 70,
                          alignment: Alignment.center,
                          child: Tab(text: label),
                        ))
                    .toList(),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search Here',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  prefixIconConstraints: BoxConstraints(minWidth: 50),
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Tab Content
              Expanded(
                child: TabBarView(
                  children: [
                    Gallerypage(),
                    Audiopage(),
                    Videopage(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
