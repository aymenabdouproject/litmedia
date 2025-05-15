import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:litmedia/pages/Navigation_Pages/multimedia/image_page.dart';
import 'package:litmedia/pages/model/multimedia.dart';
import 'package:litmedia/static/colors.dart';

class Gallerypage extends StatefulWidget {
  // Optional list of media items
  final List<Multimedia> mediaItems;

  const Gallerypage({
    super.key,
    required this.mediaItems,
  });

  @override
  State<Gallerypage> createState() => _GallerypageState();
}

class _GallerypageState extends State<Gallerypage> {
  List<String> category = [
    "All",
    "History",
    "Sci-Fi",
    "Fantasy",
    "Classics",
  ];

  List<String> urls = []; // To store media URLs
  List<String> quotes = []; // To store quotes
  bool isLoading = true;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    fetchGalleryData(); // Fetch data when the page is initialized
  }

  List<Multimedia> mediaItems = [];

  Future<void> fetchGalleryData() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Multimedia')
          .where('mediaType', isEqualTo: 'image')
          .get();

      setState(() {
        mediaItems = querySnapshot.docs.map((doc) {
          final data = doc.data();
          return Multimedia(
            booktitle: data['booktitle'] ?? '',
            quote: data['quote'] ?? '',
            mediaUrl: data['mediaUrl'] ?? '',
            bookCoverUrl: data['bookCoverUrl'] ?? '', // Fetch this field
            caption: data['caption'] ?? '',
            mediatitle: data['mediatitle'] ?? '',
            desc: data['desc'] ?? '',
            tags: List<String>.from(data['tags'] ?? []),
            bookId: data['bookId'] ?? '',
            mediaType: data['mediaType'] ?? '',
            createdBy: data['createdBy'] ?? '',
          );
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Error fetching gallery data: $e";
      });
      Fluttertoast.showToast(
        msg: errorMessage,
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: isLoading
          ? Center(
              child:
                  CircularProgressIndicator(), // Show a loader while fetching
            )
          : errorMessage.isNotEmpty
              ? Center(
                  child: Text(
                    errorMessage,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : Column(
                  children: [
                    // Categories Section
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        itemCount: category.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(child: Text(category[index])),
                          );
                        },
                      ),
                    ),

                    // GridView Section
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Number of columns
                          crossAxisSpacing: 10, // Horizontal spacing
                          mainAxisSpacing: 10, // Vertical spacing
                          childAspectRatio: 0.8, // Image + quote aspect ratio
                        ),
                        itemCount: mediaItems.length, // Total number of items
                        padding: EdgeInsets.all(10),
                        itemBuilder: (context, index) {
                          final item = mediaItems[index];

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookDetailPage(
                                    booktitle: item.booktitle,
                                    quote: item.quote,
                                    mediaUrl: item.mediaUrl,
                                    caption: item.caption,
                                    mediatitle: item.mediatitle,
                                    desc: item.desc,
                                    tags: item.tags,
                                    bookId: item.bookId,
                                    mediaType: item.mediaType,
                                    createdBy: item.createdBy,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    blurRadius: 5,
                                    spreadRadius: 2,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(12)),
                                      child: Image.network(
                                        item.mediaUrl,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                          color: Colors.grey.shade300,
                                          child: const Center(
                                            child: Icon(Icons.broken_image,
                                                color: Colors.red),
                                          ),
                                        ),
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      (loadingProgress
                                                              .expectedTotalBytes ??
                                                          1)
                                                  : null,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      item.quote,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }, //---------------------------
                      ),
                    ),
                  ],
                ),
    );
  }
}
