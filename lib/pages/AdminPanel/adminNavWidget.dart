import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:litmedia/pages/AdminPanel/Analytics.dart';
import 'package:litmedia/pages/AdminPanel/Usermanag.dart';
import 'package:litmedia/pages/AdminPanel/bookmang.dart';
import 'package:litmedia/pages/AdminPanel/dashboard.dart';
import 'package:litmedia/pages/Navigation_Pages/savepage.dart';
import 'package:litmedia/pages/auth/auth_service.dart';
import 'package:litmedia/pages/menuPages/createContent.dart';
import 'package:litmedia/pages/menuPages/deleteupdateB.dart';
import 'package:litmedia/pages/model/multimedia.dart';
import 'package:litmedia/pages/model/user.dart';
import 'package:litmedia/static/colors.dart';
import 'package:litmedia/widget/app_drawer.dart';
import 'package:litmedia/widget/media_provider.dart';
import 'package:provider/provider.dart';

class NavigationbarAdmin extends StatefulWidget {
  const NavigationbarAdmin({super.key});

  @override
  State<NavigationbarAdmin> createState() => _NavigationbarState();
}

class _NavigationbarState extends State<NavigationbarAdmin> {
  int selectedIndex = 0;
  final List pages = [DashboardPage(), UserManUI(), BookMan(), OperationPage()];
  final List<IconData> icons = [
    Icons.home,
    Icons.person,
    Icons.book,
    Icons.analytics,
  ];
  final List<String> nameindex = [
    "Dashboard",
    "User Management",
    "Book Management",
    "Operations",
  ];
  late TextEditingController searchController;
  late List<Map<String, dynamic>> menuItems;

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    searchController = TextEditingController();
    menuItems = [
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
        'navigate': Builder(
          builder: (context) => CreateContent(
            controller: searchController,
            onSearch: (query) {
              print('Searching for: $query');
            },
            onMediaUploaded: (Multimedia media) {
              Provider.of<MediaProvider>(context, listen: false)
                  .addMedia(media);
            },
          ),
        ),
      },
      {
        'icon': Icons.menu_book,
        'name': 'publish a book',
        'navigate': Deleteupdateb(),
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
    if (currentUser != null) {
      fetchUserDetails(currentUser.email!);
    }
  }

  CustomUser? _user;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      drawer: AppDrawer(menuItems: menuItems, user: _user),
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
