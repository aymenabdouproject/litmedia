import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:litmedia/pages/Navigation_Pages/savepage.dart';
import 'package:litmedia/pages/auth/auth_service.dart';
import 'package:litmedia/pages/menuPages/PublishABook.dart';
import 'package:litmedia/pages/menuPages/createContent.dart';
import 'package:litmedia/pages/menuPages/editBookPage.dart';
import 'package:litmedia/pages/model/book.dart';
import 'package:litmedia/pages/model/multimedia.dart';
import 'package:litmedia/pages/model/user.dart';
import 'package:litmedia/pages/wrapper.dart';
import 'package:litmedia/static/colors.dart';
import 'package:litmedia/widget/app_drawer.dart';
import 'package:litmedia/widget/media_provider.dart';
import 'package:provider/provider.dart';

class Deleteupdateb extends StatefulWidget {
  const Deleteupdateb({super.key});

  @override
  State<Deleteupdateb> createState() => _BookManState();
}

class _BookManState extends State<Deleteupdateb> {
  late TextEditingController searchController;
  late final List<Map<String, dynamic>> menuItems;

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Use nullable String for safety
  String? currentUserId;

  CustomUser? _user;

  @override
  void initState() {
    super.initState();
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
        'navigate': const Deleteupdateb(),
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
        'navigate': const wrapper(),
      },
    ];

    // Get current Firebase user safely
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

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Load user details from your AuthService
  void fetchUserDetails(String email) async {
    try {
      final userDetails = await AuthService().getUserDetails(email);
      setState(() {
        _user = userDetails;
      });
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }

  void navigateToEdit(Book book) async {
    print('Navigating to EditBookPage for book: ${book.title}');
    final updatedBook = await Navigator.push<Book?>(
      context,
      MaterialPageRoute(builder: (context) => EditBookPage(book: book)),
    );

    if (updatedBook != null) {
      print('Book updated: ${updatedBook.title}');
      // Handle the updated book if needed
    } else {
      print('Edit cancelled or no changes made.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: AppDrawer(menuItems: menuItems, user: _user),
        body: Stack(
          children: [
            Column(
              children: [
                // Header
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

                // Tabs
                Container(
                  color: Colors.white,
                  child: const TabBar(
                    labelColor: AppColors.vibrantBlue,
                    unselectedLabelColor: AppColors.lightPurple,
                    indicatorColor: AppColors.vibrantBlue,
                    tabs: [
                      Tab(text: 'Published'),
                      Tab(text: 'Draft'),
                    ],
                  ),
                ),

                // Tab content
                Expanded(
                  child: TabBarView(
                    children: [
                      // Published tab with Firestore books
                      currentUserId == null
                          ? const Center(
                              child: Text(
                                  'You must be logged in to see your books.'),
                            )
                          : StreamBuilder<QuerySnapshot>(
                              stream: _db
                                  .collection('book')
                                  .where('userId', isEqualTo: currentUserId)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }

                                if (snapshot.hasError) {
                                  return Center(
                                    child: Text('Error: ${snapshot.error}'),
                                  );
                                }

                                if (!snapshot.hasData ||
                                    snapshot.data!.docs.isEmpty) {
                                  return const Center(
                                    child: Text(
                                        "You haven't added any books yet."),
                                  );
                                }

                                final books = snapshot.data!.docs;

                                return ListView.builder(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: books.length,
                                  itemBuilder: (context, index) {
                                    final bookData = books[index].data()
                                        as Map<String, dynamic>;

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 100,
                                            width: 80,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: Colors.grey.shade300,
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: (bookData['bookCover'] !=
                                                          null &&
                                                      bookData['bookCover']
                                                          .toString()
                                                          .isNotEmpty)
                                                  ? Image.network(
                                                      bookData['bookCover'],
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        return const Center(
                                                            child: Icon(Icons
                                                                .broken_image));
                                                      },
                                                    )
                                                  : const Center(
                                                      child: Text('No Cover'),
                                                    ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  bookData['title'] ??
                                                      'No Title',
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  bookData['author'] ??
                                                      'Unknown Author',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: AppColors.grayPurple,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Colors.black54,
                                            ),
                                            onPressed: () {
                                              final book = Book.fromJson(
                                                  bookData); // Convert bookData to a Book object
                                              navigateToEdit(book);
                                            },
                                          ),
                                        ],
                                      ),
                                    ); //--------------------------------------------------
                                  },
                                );
                              },
                            ), //-------------------------------------------------------

                      // Draft tab placeholder
                      const Center(
                        child: Text('No drafts available'),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Publish button at bottom
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MultiFormPage()));
                },
                child: const Text('Publish a book'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
