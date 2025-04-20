import 'package:flutter/material.dart';
import 'package:litmedia/pages/Auth_Pages/checkscreen.dart';
import 'package:litmedia/pages/Navigation_Pages/savepage.dart';
import 'package:litmedia/static/colors.dart';
import 'package:litmedia/widget/CategoryButton.dart';
import 'package:litmedia/widget/bookcard.dart';
import 'package:litmedia/widget/for_you_section.dart';
import 'package:litmedia/widget/info.dart';

class Homepage extends StatelessWidget {
  final List<Map<String, dynamic>> menuItems = [
    {
      'icon': Icons.favorite,
      'name': 'favorite',
      'navigate': Savepage(),
    },
    {
      'icon': Icons.notifications,
      'name': 'notification',
      'navigate': null,
    },
    {
      'icon': Icons.flag,
      'name': 'challenge',
      'navigate': null,
    },
    {
      'icon': Icons.create,
      'name': 'create content',
      'navigate': null,
    },
    {
      'icon': Icons.menu_book,
      'name': 'publish a book',
      'navigate': null,
    },
    {
      'icon': Icons.local_offer,
      'name': 'Promotions',
      'navigate': null,
    },
    {
      'icon': Icons.settings,
      'name': 'Settings',
      'navigate': null,
    },
    {
      'icon': Icons.logout,
      'name': 'Log out',
      'navigate': Checkscreen(),
    },
  ];
  final List<Map<String, String>> books = [
    {
      "title": "Qahirah - stories",
      "author": "@author1",
    },
    {
      "title": "arabe civilization",
      "author": "@author2",
    },
    {
      "title": "my first and only love",
      "author": "@author2",
    },
  ];
  Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          backgroundColor: AppColors.darkPurple,
          child: IconTheme(
              data: IconThemeData(
                color: AppColors.offWhite,
                size: 30,
              ),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              color: AppColors.grayPurple,
                              borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.width * 0.2,
                              )),
                          height: MediaQuery.of(context).size.width * 0.2,
                          width: MediaQuery.of(context).size.width * 0.2,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Medelci Abdou",
                              style: TextStyle(color: AppColors.offWhite),
                            ),
                            TextButton(
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent), // No splash
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.zero), // Remove padding
                                tapTargetSize: MaterialTapTargetSize
                                    .shrinkWrap, // Minimizes clickable area
                              ),
                              onPressed: () {},
                              child: Text("more details"),
                            )
                          ],
                        )
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
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      menuItems[index]["navigate"],
                                ));
                          },
                        );
                      },
                    ),
                  ),
                ],
              )),
        ),
        appBar: AppBar(
          iconTheme: IconThemeData(size: 30, color: AppColors.offWhite),
          backgroundColor: AppColors.gris,
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notifications,
              ),
            )
          ],
        ),
        backgroundColor: AppColors.offWhite,
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(55),
                ),
                color: AppColors.gris,
              ),
              height: MediaQuery.of(context).size.height * 0.3,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 30, top: 16, bottom: 30),
                    child: Text(
                      "Hello User,\n What do you want to read",
                      style: TextStyle(
                          fontSize: 24,
                          fontFamily: "RozhaOne",
                          color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 16, bottom: 20),
                          child: ForYouSection(
                            title: 'The red of Sea',
                            likes: '3.3K',
                            rating: 4.3,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 16, bottom: 20),
                          child: ForYouSection(
                            title: 'The red of Sea',
                            likes: '3.3K',
                            rating: 4.3,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  top: 10, right: 10, bottom: 20),
                              child: Text(
                                "New Releases",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.only(
                                    top: 10, right: 10, bottom: 20),
                                child: Icon(Icons.add)),
                          ],
                        ),
                        SizedBox(
                          height: 230,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: books.length,
                            itemBuilder: (context, index) {
                              final book = books[index];
                              return Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: Bookcard(
                                    title: book['title']!,
                                    author: book['author']!,
                                  ));
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, right: 10),
                          child: Info(
                            image1: "images/filter1.png",
                            title: "For Readers ",
                            text:
                                "Immerse yourself in interactive stories enhanced with multimedia elements. ",
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, right: 10),
                          child: Info(
                            image1: "images/filter2.png",
                            title: "For Artists ",
                            text:
                                "Join a creative community and bring stories to life through your art.",
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, right: 10),
                          child: Info(
                            image1: "images/filter3.png",
                            title: "For Writers ",
                            text:
                                "Connect with readers and showcase your work in new, exciting way",
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(20),
                          alignment: Alignment.topLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Categories",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Icon(Icons.expand_more_sharp),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 16, right: 8),
                                  child: Categorybutton(
                                      label: 'fictions',
                                      backgroundColor: AppColors.darkPurple),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 16, right: 8),
                                  child: Categorybutton(
                                      label: 'History',
                                      backgroundColor: AppColors.greywhite),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 16, right: 8),
                                  child: Categorybutton(
                                      label: 'Poetry',
                                      backgroundColor:
                                          AppColors.electricPurple),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 16, right: 8),
                                  child: Categorybutton(
                                      label: 'Poetry',
                                      backgroundColor:
                                          AppColors.electricPurple),
                                ),
                              ],
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
