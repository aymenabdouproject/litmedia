import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:litmedia/pages/Navigation_Pages/multimedia/audio_playing.dart';
import 'package:litmedia/pages/model/multimedia.dart';
import 'package:litmedia/static/colors.dart';

class Audiopage extends StatefulWidget {
  final List<Multimedia> mediaItems;

  const Audiopage({super.key, required this.mediaItems});

  @override
  State<Audiopage> createState() => _AudiopageState();
}

class _AudiopageState extends State<Audiopage> {
  List<Multimedia> continueListeningItems = []; // Data for Continue Listening
  List<Multimedia> popularAudiobooks = []; // Data for Popular Audiobooks
  List<String> category = [
    "All",
    "History",
    "Sci-Fi",
    "Fantasy",
    "Classics",
  ];

  @override
  void initState() {
    super.initState();
    fetchAllMultimediaItems();
  }

  Future<void> fetchAllMultimediaItems() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('Multimedia').get();

      if (querySnapshot.docs.isEmpty) {
        Fluttertoast.showToast(
          msg: "No multimedia items found.",
          backgroundColor: Colors.orange,
        );
        return;
      }

      List<Multimedia> allMediaItems = [];
      List<Multimedia> continueItems = [];
      List<Multimedia> popularItems = [];

      for (var doc in querySnapshot.docs) {
        final data = doc.data();

        // Create Multimedia object
        Multimedia multimedia = Multimedia(
          mediaType: data['mediaType'] ?? '',
          mediaUrl: data['mediaUrl'] ?? '',
          caption: data['caption'] ?? '',
          booktitle: data['booktitle'] ?? '',
          desc: data['desc'] ?? '',
          createdBy: data['createdBy'] ?? '',
          quote: data['quote'] ?? '',
          mediatitle: data['mediatitle'] ?? '',
          bookauthor: data['bookauthor'] ?? 'Unknown',
          bookCoverUrl: data['bookCoverUrl'] ?? 'bookcover',
          bookId: data['bookId'] ?? '',
          tags: List<String>.from(data['tags'] ?? []),
        );

        // Split data into "Continue Listening" and "Popular Audiobooks"
        if (data['isPopular'] == true) {
          popularItems.add(multimedia);
        } else {
          continueItems.add(multimedia);
        }

        allMediaItems.add(multimedia);
      }

      setState(() {
        continueListeningItems = continueItems;
        popularAudiobooks = popularItems;
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error fetching media data: $e",
        backgroundColor: Colors.red,
      );
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.002),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Continue Listening Section
              Text(
                "Continue listening",
                style: TextStyle(fontSize: screenWidth * 0.05),
              ),
              SizedBox(height: screenHeight * 0.03),
              SizedBox(
                height: screenHeight * 0.2,
                child: continueListeningItems.isNotEmpty
                    ? ListView.builder(
                        itemCount: continueListeningItems.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AudioPlayerUrl(
                                    mediaItem: continueListeningItems[index],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: screenWidth * 0.4,
                              margin: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.02),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: AppColors.electricPurple,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      continueListeningItems[index].caption ??
                                          'No Caption',
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          "No audio items available",
                          style: TextStyle(
                              color: Colors.grey, fontSize: screenWidth * 0.04),
                        ),
                      ),
              ),

              SizedBox(height: screenHeight * 0.03),
              Text(
                "Collections",
                style: TextStyle(fontSize: screenWidth * 0.05),
              ),
              SizedBox(
                height: screenHeight * 0.07,
                child: ListView.builder(
                  itemCount: category.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.03,
                          vertical: screenHeight * 0.01),
                      margin:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
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

              SizedBox(height: screenHeight * 0.03),
              // Popular Audiobooks Section
              Text(
                "Popular Audiobooks",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: screenWidth * 0.05),
              ),
              SizedBox(height: screenHeight * 0.02),
              SizedBox(
                height: screenHeight * 0.15,
                child: popularAudiobooks.isNotEmpty
                    ? ListView.builder(
                        itemCount: popularAudiobooks.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Container(
                            width: screenWidth * 0.45,
                            height: screenHeight * 0.11,
                            margin: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.02),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppColors.electricPurple,
                            ),
                            child: Center(
                              child: Text(
                                popularAudiobooks[index].caption ??
                                    "No Caption",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          "No popular audiobooks available",
                          style: TextStyle(
                              color: Colors.grey, fontSize: screenWidth * 0.04),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
