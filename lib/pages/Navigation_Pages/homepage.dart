import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:litmedia/pages/Navigation_Pages/PublishABook.dart';
import 'package:litmedia/pages/Navigation_Pages/savepage.dart';
import 'package:litmedia/pages/auth/auth_service.dart';
import 'package:litmedia/pages/model/user.dart';
import 'package:litmedia/pages/service/database.dart';
import 'package:litmedia/pages/wrapper.dart';
import 'package:litmedia/static/colors.dart';
import 'package:litmedia/widget/CategoryButton.dart';
import 'package:litmedia/widget/bookcard.dart';
import 'package:litmedia/widget/for_you_section.dart';
import 'package:litmedia/widget/info.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
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
      'navigate': MultiFormPage(),
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
      'navigate': 'logout',
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

  CustomUser? _user;

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      fetchUserDetails(currentUser.email!);
    }
  }

  void fetchUserDetails(String email) async {
    try {
      final userDetails = await AuthService().getUserDetails(email);
      setState(() {
        _user = userDetails;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
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
                      margin:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
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
                          _user?.username ?? '',
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
                            MaterialPageRoute(
                                builder: (context) => destination),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          iconTheme: IconThemeData(size: 30, color: AppColors.offWhite),
          backgroundColor: AppColors.gris,
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.notifications),
            ),
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
              height: screenHeight * 0.35,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        left: screenWidth * 0.08, top: screenHeight * 0.02),
                    child: Text(
                      "Hello ${_user?.username ?? ''},\nWhat do you want to read?",
                      style: TextStyle(
                        fontSize: screenWidth * 0.06,
                        fontFamily: "RozhaOne",
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Expanded(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: screenWidth * 0.03),
                          child: ForYouSection(
                            title: 'The red of Sea',
                            likes: '3.3K',
                            rating: 4.3,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: screenWidth * 0.04),
                          child: ForYouSection(
                            title: 'The red of Sea',
                            likes: '3.3K',
                            rating: 4.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(screenWidth * 0.03),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "New Releases",
                                style: TextStyle(
                                  fontSize: screenWidth * 0.05,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(Icons.add),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.03),
                          SizedBox(
                            height: screenHeight * 0.3,
                            child: StreamBuilder<QuerySnapshot>(
                                stream: _db.collection('book').snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }
                                  if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Error: ${snapshot.error}'));
                                  }
                                  final book = snapshot.data!.docs;
                                  return ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: books.length,
                                    itemBuilder: (context, index) {
                                      var Book = book[index].data()
                                          as Map<String, dynamic>;
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            right: screenWidth * 0.04),
                                        child: Bookcard(
                                          title: Book['title'] ?? 'no Title',
                                          author: Book['author'] ??
                                              'Unknown Author',
                                          imageUrl: Book['bookCover'] ?? '',
                                        ),
                                      );
                                    },
                                  );
                                }),
                          ),
                          SizedBox(height: screenHeight * 0.03),
                          Info(
                            image1: "images/filter1.png",
                            title: "For Readers",
                            text:
                                "Immerse yourself in interactive stories enhanced with multimedia elements.",
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Info(
                            image1: "images/filter2.png",
                            title: "For Artists",
                            text:
                                "Join a creative community and bring stories to life through your art.",
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Info(
                            image1: "images/filter3.png",
                            title: "For Writers",
                            text:
                                "Connect with readers and showcase your work in new, exciting ways.",
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Container(
                            margin: EdgeInsets.all(screenWidth * 0.05),
                            alignment: Alignment.topLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Categories",
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.05,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(Icons.expand_more_sharp),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.03),
                                Categorybutton(
                                  label: 'Fictions',
                                  backgroundColor: AppColors.darkPurple,
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.03),
                                Categorybutton(
                                  label: 'History',
                                  backgroundColor: AppColors.greywhite,
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.03),
                                Categorybutton(
                                  label: 'Poetry',
                                  backgroundColor: AppColors.electricPurple,
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.03),
                                Categorybutton(
                                  label: 'Science',
                                  backgroundColor: AppColors.electricPurple,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
