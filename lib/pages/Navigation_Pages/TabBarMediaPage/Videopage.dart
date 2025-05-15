import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:litmedia/pages/Navigation_Pages/multimedia/video_page.dart';
import 'package:litmedia/pages/model/multimedia.dart';
import 'package:litmedia/static/colors.dart';
import 'package:litmedia/widget/videoThumbailWidget.dart';

class Videopage extends StatefulWidget {
  final List<Multimedia> mediaItems;

  const Videopage({super.key, required this.mediaItems});

  @override
  State<Videopage> createState() => _VideoPageState();
}

class _VideoPageState extends State<Videopage> {
  List<Multimedia> videoItems = [];
  bool isLoading = true;
  String errorMessage = "";
  @override
  void initState() {
    super.initState();
    fetchVideoData();
  }

  Future<void> fetchVideoData() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Multimedia')
          .where('mediaType', isEqualTo: 'video')
          .get();

      setState(() {
        videoItems = querySnapshot.docs.map((doc) {
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
    List<String> category = [
      "All",
      "History",
      "Sci-Fi",
      "Fantasy",
      "Classics",
    ];

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Chips
              SizedBox(
                height: screenHeight * 0.07,
                child: ListView.builder(
                  itemCount: category.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.03,
                        vertical: screenHeight * 0.01,
                      ),
                      margin:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.withOpacity(0.8)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          category[index],
                          style: TextStyle(color: Colors.grey.withOpacity(0.8)),
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              // Continue Watching
              Text(
                "Continue Watching",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: screenWidth * 0.05),
              ),

              SizedBox(height: screenHeight * 0.03),
              SizedBox(
                // 30% of screen height, responsive
                height: MediaQuery.of(context).size.height * 0.28,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Video list
                    Expanded(
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: videoItems.length,
                          itemBuilder: (context, index) {
                            return Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VideoPlayerPage(
                                          mediaItem: videoItems[index]),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.03,
                                    vertical: screenHeight * 0.01,
                                  ),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.02),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(0.8)),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        VideoThumbnailWidget(
                                            videoUrl:
                                                videoItems[index].mediaUrl),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black45,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Icon(Icons.play_arrow,
                                                color: Colors.white, size: 32),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
//-----------------------------------------------
                          ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        "Video Title",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 13, 11, 11),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.03),

              // Author Interviews
              Text(
                "Popular videos",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.05,
                ),
              ),

              SizedBox(height: screenHeight * 0.03),

              SizedBox(
                // 30% of screen height, responsive
                height: MediaQuery.of(context).size.height * 0.28,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Video list
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: AspectRatio(
                              aspectRatio: 16 / 9, // Keep standard ratio
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    "Video ${index + 1}",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        "",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 13, 11, 11),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              // Book Trailers

              SizedBox(height: screenHeight * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}
