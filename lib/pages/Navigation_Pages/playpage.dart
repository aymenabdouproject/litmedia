import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:litmedia/pages/Navigation_Pages/TabBarMediaPage/Audiopage.dart';
import 'package:litmedia/pages/Navigation_Pages/TabBarMediaPage/Gallerypage.dart';
import 'package:litmedia/pages/Navigation_Pages/TabBarMediaPage/Videopage.dart';
import 'package:litmedia/pages/Navigation_Pages/savepage.dart';
import 'package:litmedia/pages/auth/auth_service.dart';
import 'package:litmedia/pages/menuPages/createContent.dart';
import 'package:litmedia/pages/menuPages/deleteupdateB.dart';
import 'package:litmedia/pages/model/multimedia.dart';
import 'package:litmedia/pages/model/user.dart';
import 'package:litmedia/static/colors.dart';
import 'package:litmedia/widget/app_drawer.dart';

class Mediapage extends StatefulWidget {
  final Map<MediaType, String?> uploadedMediaUrls;

  const Mediapage({
    super.key,
    required this.uploadedMediaUrls,
  });

  @override
  State<Mediapage> createState() => _MediapageState();
}

class _MediapageState extends State<Mediapage> {
  late TextEditingController searchController;
  late List<Map<String, dynamic>> menuItems;
  late Map<MediaType, String?> filteredMediaUrls;
  CustomUser? _user;

  List<Multimedia> get galleryItems {
    final url = filteredMediaUrls[MediaType.image];
    return url != null
        ? [
            Multimedia(
                mediaType: 'image',
                caption: 'Uploaded Image',
                booktitle: '',
                quote: '',
                mediaUrl: url,
                bookId: '')
          ]
        : [];
  }

  List<Multimedia> get audioItems {
    final url = filteredMediaUrls[MediaType.audio];
    return url != null
        ? [
            Multimedia(
                mediaType: 'audio',
                caption: 'Uploaded Audio',
                booktitle: '',
                quote: '',
                mediaUrl: url,
                bookId: '')
          ]
        : [];
  }

  List<Multimedia> get videoItems {
    final url = filteredMediaUrls[MediaType.video];
    return url != null
        ? [
            Multimedia(
                mediaType: 'video',
                caption: 'Uploaded Video',
                booktitle: '',
                quote: '',
                mediaUrl: url,
                bookId: '')
          ]
        : [];
  }

  void _searchMedia(String query) {
    setState(() {
      final filter = (String caption) =>
          caption.toLowerCase().contains(query.toLowerCase());

      final defaultCaptions = {
        MediaType.image: 'Uploaded Image',
        MediaType.audio: 'Uploaded Audio',
        MediaType.video: 'Uploaded Video',
      };

      filteredMediaUrls = Map.fromEntries(
        widget.uploadedMediaUrls.entries.map((entry) {
          final type = entry.key;
          final url = entry.value;
          final caption = defaultCaptions[type]!;
          return (url != null && filter(caption))
              ? MapEntry(type, url)
              : MapEntry(type, null);
        }),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    filteredMediaUrls = Map.of(widget.uploadedMediaUrls);

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      fetchUserDetails(currentUser.email!);
    }

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
        'navigate': CreateContent(
          controller: searchController,
          onSearch: (query) {
            print('Searching for: $query');
          },
          onMediaUploaded: (Multimedia media) {
            setState(() {
              if (media.mediaType == 'image') {
                filteredMediaUrls[MediaType.image] = media.mediaUrl;
              } else if (media.mediaType == 'audio') {
                filteredMediaUrls[MediaType.audio] = media.mediaUrl;
              } else if (media.mediaType == 'video') {
                filteredMediaUrls[MediaType.video] = media.mediaUrl;
              }
            });
          },
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
  }

  void fetchUserDetails(String email) async {
    try {
      final userDetails = await AuthService().getUserDetails(email);
      setState(() {
        _user = userDetails;
      });
    } catch (e) {
      print('Error fetching user: $e');
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  final List<String> tabLabels = ["GALLERY", "AUDIO", "VIDEO"];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return DefaultTabController(
      length: tabLabels.length,
      child: Scaffold(
        backgroundColor: AppColors.offWhite,
        drawer: AppDrawer(menuItems: menuItems, user: _user),
        appBar: AppBar(
          backgroundColor: const Color(0xFF251B3E),
          iconTheme: IconThemeData(size: 30, color: AppColors.offWhite),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.notifications,
                  size: screenWidth * 0.07, color: AppColors.offWhite),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(screenHeight * 0.1),
            child: Container(
              padding: const EdgeInsets.all(5),
              height: screenHeight * 0.08,
              width: screenWidth,
              decoration: const BoxDecoration(
                color: AppColors.offWhite,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(40)),
              ),
              child: TabBar(
                isScrollable: true,
                indicator: BoxDecoration(
                  color: AppColors.electricPurple,
                  borderRadius: BorderRadius.circular(12),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: screenWidth * 0.04,
                ),
                tabs: tabLabels
                    .map((label) => Container(
                          width: screenWidth * 0.25,
                          alignment: Alignment.center,
                          child: Tab(text: label),
                        ))
                    .toList(),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            children: [
              TextField(
                controller: searchController,
                onChanged: _searchMedia,
                decoration: InputDecoration(
                  hintText: 'Search Here',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  prefixIconConstraints: BoxConstraints(
                    minWidth: screenWidth * 0.1,
                  ),
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.025),
              Expanded(
                child: TabBarView(
                  children: [
                    Gallerypage(mediaItems: galleryItems),
                    Audiopage(mediaItems: audioItems),
                    Videopage(mediaItems: videoItems),
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
