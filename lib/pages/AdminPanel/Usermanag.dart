import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

class UserManUI extends StatefulWidget {
  const UserManUI({super.key});

  @override
  State<UserManUI> createState() => _UserManUIState();
}

class _UserManUIState extends State<UserManUI> {
  final List<Map<String, String>> users = [
    {
      "name": "Sarah Johnson",
      "email": "sarah@example.com",
      "role": "Admin",
      "status": "Active",
      "lastLogin": "2025-04-20",
    },
    {
      "name": "Mark Lee",
      "email": "mark@example.com",
      "role": "User",
      "status": "Inactive",
      "lastLogin": "2025-04-10",
    },
  ];

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

  Future<void> deleteUser(String uid) async {
    try {
      // Delete user document from Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).delete();
      print('User document deleted successfully from Firestore.');

      // Delete user from Firebase Authentication
      await FirebaseAuth.instance.currentUser?.delete();
      print('User deleted successfully from Firebase Authentication.');
    } catch (e) {
      print('Error deleting user: $e');
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
          Container(
            decoration: const BoxDecoration(
              color: AppColors.gris,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(55)),
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
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
                decoration: InputDecoration(
                  hintText: "Search by name or email",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (query) {
                  setState(() {});
                }),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No users found."));
                }

                final users = snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;

                  // Handle potential null values for createdAt
                  final createdAt = data['createdAt'] != null
                      ? (data['createdAt'] as Timestamp).toDate()
                      : null;

                  return {
                    "uid": doc.id,
                    "username": data['username'] ?? 'N/A',
                    "email": data['email'] ?? 'N/A',
                    "createdAt": createdAt != null
                        ? "${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')} ${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}"
                        : "N/A",
                  };
                }).where((user) {
                  final query = searchController.text.toLowerCase();
                  final name = user['username']!.toLowerCase();
                  final email = user['email']!.toLowerCase();

                  return name.contains(query) || email.contains(query);
                }).toList();

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 4,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.indigo.shade200,
                          child: Text(user['username']![0]),
                        ),
                        title: Text(user['username']!),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user['email']!),
                            Text('created at ${user['createdAt']}'),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.edit, size: 20),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () {
                                    // Show confirmation dialog before deleting
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Confirm Deletion'),
                                          content: const Text(
                                              'Are you sure you want to delete this user?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                // Close the dialog without deleting
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                // Confirm deletion
                                                deleteUser(user['uid']!);
                                                Navigator.of(context)
                                                    .pop(); // Close the dialog
                                              },
                                              child: const Text('Delete'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: const Icon(Icons.delete, size: 20),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
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
