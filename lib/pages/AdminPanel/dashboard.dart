import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:litmedia/pages/Navigation_Pages/savepage.dart';
import 'package:litmedia/pages/auth/auth_service.dart';
import 'package:litmedia/pages/menuPages/createContent.dart';
import 'package:litmedia/pages/menuPages/deleteupdateB.dart';
import 'package:litmedia/pages/model/dashboardM.dart';
import 'package:litmedia/pages/model/multimedia.dart';
import 'package:litmedia/pages/model/user.dart';
import 'package:litmedia/static/colors.dart';
import 'package:litmedia/widget/app_drawer.dart';
import 'package:litmedia/widget/chart.dart';
import 'package:litmedia/widget/chartTwo.dart';
import 'package:litmedia/widget/media_provider.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final List<DashboardItem> items = [
    DashboardItem("Total Users", "1,230", Icons.person),
    DashboardItem("Books Available", "4,521", Icons.book),
    DashboardItem("Borrowed Books", "327", Icons.bookmark),
    DashboardItem("Overdue", "29", Icons.warning),
    DashboardItem("New Requests", "76", Icons.pending),
    DashboardItem("Penalties", "12", Icons.report),
  ];

  final List<FlSpot> borrowedData = [
    const FlSpot(0, 120), // January
    const FlSpot(1, 150), // February
    const FlSpot(2, 180), // March
    const FlSpot(3, 130), // April
    const FlSpot(4, 170), // May
    const FlSpot(5, 190), // June
  ];
  final List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
  late TextEditingController searchController;
  late List<Map<String, dynamic>> menuItems;
  String? currentUserId;
  CustomUser? _user;
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

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(menuItems: menuItems, user: _user),
      body: Column(
        children: [
          // Custom App Bar
          Container(
            height: kToolbarHeight + MediaQuery.of(context).padding.top,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              left: 16,
              right: 16,
            ),
            color: AppColors.gris,
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

          // Welcome Text Below App Bar Controls
          Material(
            elevation: 4,
            color: AppColors.gris,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(55),
            ),
            child: Container(
              width: double.infinity,
              color: AppColors.gris,
              padding: const EdgeInsets.only(left: 24, top: 12, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Welcome to the Admin Panel",
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: "RozhaOne",
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Here's a quick summary of today's activity.",
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),

          // Continue with the rest of your content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  // Add space between the top card and the grid
                  const Text(
                    "Books Borrowed Over Last 6 Months",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  LineChartSample2(),
                  const SizedBox(height: 16),
                  const Text(
                    "Most popular categories",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ChartTwo(),
                  const SizedBox(height: 40),

                  LayoutBuilder(
                    builder: (context, constraints) {
                      // Dynamically calculate the number of columns based on screen width
                      int crossAxisCount = (constraints.maxWidth / 150)
                          .floor(); // Adjusted for smaller cards
                      crossAxisCount = crossAxisCount < 1
                          ? 1
                          : crossAxisCount; // Ensure at least 1 column

                      const double spacing = 12;

                      return GridView.builder(
                        shrinkWrap:
                            true, // Prevent GridView from taking infinite height
                        physics:
                            const NeverScrollableScrollPhysics(), // Disable GridView scrolling
                        itemCount: items.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: spacing,
                          mainAxisSpacing: spacing,
                          childAspectRatio:
                              0.8, // Adjusted for smaller card size
                        ),
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    item.icon,
                                    size: 36,
                                    color: Colors.indigo,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    item.title,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.value,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
