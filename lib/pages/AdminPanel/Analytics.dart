import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:litmedia/pages/AdminPanel/addUser.dart';
import 'package:litmedia/pages/Navigation_Pages/savepage.dart';
import 'package:litmedia/pages/auth/auth_service.dart';
import 'package:litmedia/pages/menuPages/PublishABook.dart';
import 'package:litmedia/pages/menuPages/createContent.dart';
import 'package:litmedia/pages/menuPages/deleteupdateB.dart';
import 'package:litmedia/pages/model/multimedia.dart';
import 'package:litmedia/pages/model/user.dart';
import 'package:litmedia/static/colors.dart';
import 'package:litmedia/widget/app_drawer.dart';
import 'package:litmedia/widget/media_provider.dart';
import 'package:provider/provider.dart';

class OperationPage extends StatefulWidget {
  const OperationPage({super.key});

  @override
  State<OperationPage> createState() => _OperationPageState();
}

class _OperationPageState extends State<OperationPage> {
  late TextEditingController searchController;
  late List<Map<String, dynamic>> menuItems;
  String? currentUserId;
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
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      currentUserId = user.uid;
      if (user.email != null) {
        fetchUserDetails(user.email!);
      }
    } else {
      currentUserId = null;
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

  CustomUser? _user;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(menuItems: menuItems, user: _user),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top App Bar
            Container(
              decoration: const BoxDecoration(
                color: AppColors.gris,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(55),
                ),
              ),
              padding: const EdgeInsets.only(
                top: 32,
                left: 16,
                right: 16,
                bottom: 24,
              ),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(
                        Icons.menu,
                        size: 30,
                        color: AppColors.offWhite,
                      ),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.notifications,
                      color: AppColors.offWhite,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Manage Books & Users Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(42), // Increased padding
                decoration: BoxDecoration(
                  color: AppColors.mediumPurple,
                  borderRadius: BorderRadius.circular(16), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4), // Shadow position
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Manage Books & Users",
                        style: TextStyle(
                          fontSize: 22, // Increased font size
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // White text for better contrast
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Add Book Button
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MultiFormPage(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add),
                          label: const Text("Add Book"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppColors.purpleclair, // Custom button color
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Add User Button
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddUserUI(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.person_add),
                          label: const Text("Add User"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppColors.purpleclair, // Custom button color
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Delete Book Button
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Navigate to Delete Book Page
                          },
                          icon: const Icon(Icons.delete),
                          label: const Text("Delete Book"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppColors.purpleclair, // Custom button color
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Navigate to Add Book Page
                          },
                          icon: const Icon(Icons.email),
                          label: const Text("Send news letters"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppColors.purpleclair, // Custom button color
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
