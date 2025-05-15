import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:litmedia/pages/Navigation_Pages/playpage.dart';
import 'package:litmedia/pages/Navigation_Pages/savepage.dart';
import 'package:litmedia/pages/auth/auth_service.dart';
import 'package:litmedia/pages/menuPages/deleteupdateB.dart';
import 'package:litmedia/pages/model/multimedia.dart';
import 'package:litmedia/pages/model/user.dart';
import 'package:litmedia/static/colors.dart';
import 'package:litmedia/widget/app_drawer.dart';
import 'package:litmedia/widget/audio_player_preview.dart';
import 'package:litmedia/widget/custumDropDown.dart';
import 'package:litmedia/widget/image_preview_area.dart';
import 'package:litmedia/widget/media_provider.dart';
import 'package:litmedia/widget/navigationbar.dart';
import 'package:litmedia/widget/textfieldcreate.dart';
import 'package:litmedia/widget/video_timeline_editor.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';

class CreateContent extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSearch;
  final Function(Multimedia) onMediaUploaded;

  const CreateContent({
    super.key,
    required this.controller,
    required this.onSearch,
    required this.onMediaUploaded,
  });

  @override
  State<CreateContent> createState() => _CreateContentState();
}

class _CreateContentState extends State<CreateContent> {
  String? _uploadedMediaUrl; // Single variable for all media URLs
  MediaType? _mediaType; // To track the type of media being uploaded
  String? selectedBookId; // Store the selected book ID
  List<DropdownMenuItem<String>> books = [];
  String? quote;

  void handleMediaUploaded(String url) {
    setState(() {
      _uploadedMediaUrl = url; // Update the shared URL variable
    });
    print("Uploaded Media URL: $_uploadedMediaUrl ");
  }

  Map<MediaType, String?> uploadedMediaUrls = {
    MediaType.audio: null,
    MediaType.image: null,
    MediaType.video: null,
  };
  List<String> allquotes = [];

  void _addMediaUrl(MediaType mediaType, String mediaUrl) {
    setState(() {
      uploadedMediaUrls[mediaType] =
          mediaUrl; // Add or update the media URL for the specific media type
    });
  }

  List<Multimedia> mediaItems = [];

  int currentStep = 0;
  bool get isFirstStep => currentStep == 0;
  bool get isLastStep => currentStep == steps(context).length - 1;
  bool isComplete = false;

  late TextEditingController _titleBook;
  late TextEditingController _quoteBook;
  late TextEditingController _mediaDesc;
  late TextEditingController _searchController;
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _tagsController;
  late TextEditingController _audioCaptionController;
  late TextEditingController _imageCaptionController;
  late TextEditingController _videoCaptionController;
  late TextEditingController _mediaTitleController;

  final ImagePicker _picker = ImagePicker(); // Define the ImagePicker instance

  late TextEditingController searchController;
  late final List<Map<String, dynamic>> menuItems;

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Use nullable String for safety
  String? currentUserId;
  CustomUser? _user;

  @override
  void initState() {
    super.initState();
    _titleBook = TextEditingController();
    _quoteBook = TextEditingController();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _tagsController = TextEditingController();
    _mediaDesc = TextEditingController();
    _searchController = TextEditingController();
    _audioCaptionController = TextEditingController();
    _imageCaptionController = TextEditingController();
    _videoCaptionController = TextEditingController();
    searchController = TextEditingController();
    _mediaTitleController = TextEditingController();
    fetchAllMultimediaItems();

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
    fetchBooks();
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
    _titleBook.dispose();
    _quoteBook.dispose();
    _mediaDesc.dispose();
    _searchController.dispose();

    _descriptionController.dispose();
    _tagsController.dispose();
    _audioCaptionController.dispose();
    _imageCaptionController.dispose();
    _videoCaptionController.dispose();
    searchController.dispose();
    _mediaTitleController.dispose();
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

  List<Map<String, dynamic>> booksData = [];
  String? selectedBookAuthor;

  Future<void> fetchBooks() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('book').get();

      setState(() {
        booksData = querySnapshot.docs.map((doc) {
          return {
            'id': doc.id,
            'title': doc['title'],
            'author': doc['author'],
          };
        }).toList();

        books = booksData.map((book) {
          return DropdownMenuItem<String>(
            value: book['id'],
            child: Text(book['title']!),
          );
        }).toList();
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error fetching books: $e",
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> fetchAllMultimediaItems() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('Multimedia').get();

      // Check if querySnapshot is not empty
      if (querySnapshot.docs.isEmpty) {
        Fluttertoast.showToast(
          msg: "No multimedia items found.",
          backgroundColor: Colors.orange,
        );
        return;
      }

      // Create an empty map to hold uploaded media URLs
      Map<MediaType, String?> uploadedMediaUrls = {
        MediaType.image: null,
        MediaType.audio: null,
        MediaType.video: null,
      };

      // Update the map with the fetched media URLs
      for (var doc in querySnapshot.docs) {
        final mediaData = doc.data();
        final mediaType = mediaData['mediaType'];

        if (mediaType != null) {
          switch (mediaType) {
            case 'image':
              uploadedMediaUrls[MediaType.image] = mediaData['mediaUrl'];
              break;
            case 'audio':
              uploadedMediaUrls[MediaType.audio] = mediaData['mediaUrl'];
              break;
            case 'video':
              uploadedMediaUrls[MediaType.video] = mediaData['mediaUrl'];
              break;
          }
        }
      }

      setState(() {
        this.uploadedMediaUrls = uploadedMediaUrls;
      });

      print('Fetched Multimedia URLs: ${uploadedMediaUrls.length}');
    } catch (e) {
      // Handle errors
      Fluttertoast.showToast(
        msg: "Error fetching media data: $e",
        backgroundColor: Colors.red,
      );
      print("Error: $e"); // Optionally log the error for debugging
    }
  }

  String? selectedBookTitle;

  void _addQuotes(String quote) {
    if (quote.trim().isNotEmpty) {
      setState(() {
        allquotes.add(quote.trim());
        _quoteBook.text = quote.trim(); // Keep _quoteBook.text in sync
      });
    } else {
      Fluttertoast.showToast(
        msg: "Cannot add an empty quote.",
        backgroundColor: Colors.red,
      );
    }
  }

  String? _uploadedImageUrl;

  Future<void> saveMediaContent() async {
    if (_mediaType == null) {
      Fluttertoast.showToast(
        msg: "Please select a media type first!",
        backgroundColor: Colors.red,
      );
      return;
    }

    if (uploadedMediaUrls[_mediaType] == null) {
      Fluttertoast.showToast(
        msg: "Please upload a file for the selected media type!",
        backgroundColor: Colors.red,
      );
      return;
    }

    if (selectedBookId == null) {
      Fluttertoast.showToast(
        msg: "Please select a book first!",
        backgroundColor: Colors.red,
      );
      return;
    }

    String id = randomAlphaNumeric(10);
    String? caption = _mediaType == MediaType.audio
        ? _audioCaptionController.text
        : _mediaType == MediaType.video
            ? _videoCaptionController.text
            : _imageCaptionController.text;

    final selectedBook = booksData.firstWhere(
      (book) => book['id'] == selectedBookId,
      orElse: () => {
        'id': '',
        'title': 'Unknown',
        'author': 'Unknown',
      }, // Fallback in case no match is found
    );

    try {
      print(
          "Saving Media: Type: $_mediaType, URL: ${uploadedMediaUrls[_mediaType]}");

      await FirebaseFirestore.instance.collection('Multimedia').doc(id).set({
        'booktitle': selectedBookTitle,
        'mediaType': _mediaType?.name,
        'mediaUrl': uploadedMediaUrls[_mediaType] ?? '',
        'quote': _quoteBook.text.trim(),
        'caption': caption,
        'mediatitle': _mediaTitleController.text,
        'desc': _descriptionController.text,
        'createdBy': _user?.username,
        'tags': _tagsController.text.split(','),
        'bookCoverUrl': _uploadedImageUrl,
        'bookId': selectedBookId,
        'bookauthor': selectedBookAuthor,
      });

      Fluttertoast.showToast(
        msg: "Media added successfully!",
        backgroundColor: Colors.green,
      );

      setState(() {
        mediaItems.add(Multimedia(
          mediaUrl: uploadedMediaUrls[_mediaType!]!,
          mediaType: _mediaType!.name,
          booktitle: selectedBook['title'],
          desc: _descriptionController.text,
          quote: _quoteBook.text.trim(),
          bookId: '',
          mediatitle: _mediaTitleController.text,
          bookauthor: selectedBookAuthor,
        ));
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Navigationbar(
            uploadedMediaUrls: uploadedMediaUrls,
          ),
        ),
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error: $e",
        backgroundColor: Colors.red,
      );
    }
  }

//________________________________________________________________________
  List<Step> steps(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return [
      //------------------------------------------
      Step(
        title: Text(
          '1',
          style: TextStyle(
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Form(
          key: _formKey1,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFF6F6F6), // light neutral background
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create connection content for this book :',
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(),
                SizedBox(width: screenWidth * 0.04),

                // Book Title Field
                Text(
                  'Book Title *',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Flexible(
                      child: CustomDropdown<String>(
                        value: selectedBookId,
                        items: books,
                        hintText: selectedBookTitle,
                        onChanged: (value) {
                          setState(() {
                            selectedBookId = value;
                            selectedBookTitle = booksData.firstWhere(
                                (book) => book['id'] == value)['title'];
                            selectedBookAuthor = booksData.firstWhere(
                                (book) => book['id'] == value)['author'];
                            _uploadedImageUrl = booksData.firstWhere((book) =>
                                book['id'] == value)['BookCoverImageUrl'];
                          });
                        },
                      ),
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.025),

                // Search Bar
                Text(
                  'Search Quote *',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Textfieldcreate(
                  controller: _searchController,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Required field' : null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Search for a quote...',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        final String quote = _searchController.text.trim();
                        if (quote.isNotEmpty) {
                          _addQuotes(quote); // Add to allquotes
                          _quoteBook.text =
                              quote; // Synchronize _quoteBook with the entered quote
                          _searchController.clear(); // Clear the input field
                          Fluttertoast.showToast(
                            msg: "Quote added successfully!",
                            backgroundColor: Colors.green,
                          );
                        } else {
                          Fluttertoast.showToast(
                            msg: "Please enter a quote!",
                            backgroundColor: Colors.red,
                          );
                        }
                      },
                    ),
                  ),
                  text1: '',
                  text2: '',
                  prefix: Icon(null),
                  suffix: Icon(null),
                  obscureText: false,
                  minLines: 3,
                ),

                SizedBox(height: screenHeight * 0.025),

                // Suggested Quotes

                SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),

      //------------------------------------------
      Step(
        title: Text(
          '2',
          style: TextStyle(
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Form(
          key: _formKey2,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFF6F6F6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose Media Type:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Divider(),
                RadioListTile<MediaType>(
                  title: Text('Audio'),
                  value: MediaType.audio,
                  groupValue: _mediaType,
                  onChanged: (value) {
                    setState(() {
                      _mediaType = value!;
                    });
                  },
                ),
                RadioListTile<MediaType>(
                  title: Text('Image'),
                  value: MediaType.image,
                  groupValue: _mediaType,
                  onChanged: (value) {
                    setState(() {
                      _mediaType = value!;
                    });
                  },
                ),
                RadioListTile<MediaType>(
                  title: Text('Video'),
                  value: MediaType.video,
                  groupValue: _mediaType,
                  onChanged: (value) {
                    setState(() {
                      _mediaType = value!;
                    });
                  },
                ),
                SizedBox(height: screenHeight * 0.03),
                if (_mediaType == MediaType.audio) ...[
                  Text(
                    '🎵 Upload & Preview Audio',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  SizedBox(height: screenHeight * 0.0125),
                  AudioPlayerPreview(
                    onMediaUploaded: (url, mediaType) {
                      handleMediaUploaded(url);
                      _addMediaUrl(MediaType.audio, url);
                    },
                  ),
                  SizedBox(height: screenHeight * 0.025),
                  Text(
                    'Caption: What does this sound express about the quote?',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Textfieldcreate(
                    controller: _audioCaptionController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Describe what this audio expresses',
                    ),
                    text1: '',
                    text2: '',
                    prefix: Icon(null),
                    suffix: Icon(null),
                    obscureText: false,
                    validator: (String? value) {
                      return null;
                    },
                  ),
                ] else if (_mediaType == MediaType.image) ...[
                  Text(
                    '🖼 Upload Image / AI Generate',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  SizedBox(height: screenHeight * 0.0125),
                  // Add image upload or AI generation widget
                  SizedBox(width: screenWidth * 0.04),
                  ImagePreviewArea(
                    onMediaUploaded: (url, mediaType) {
                      handleMediaUploaded(url);
                      _addMediaUrl(MediaType.image, url);
                    },
                  ),
                  SizedBox(height: screenHeight * 0.025),
                  Text(
                    'Edit: Crop, Filter, Annotate',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: screenHeight * 0.0125),
                  // Add image editing tools here
                  SizedBox(width: screenWidth * 0.04),
                  Text(
                    'Caption: Explain this image\'s connection to the quote',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Textfieldcreate(
                    controller: _imageCaptionController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText:
                          'Explain the connection between the image and quote',
                    ),
                    text1: '',
                    text2: '',
                    prefix: Icon(null),
                    suffix: Icon(null),
                    obscureText: false,
                    validator: (String? value) {
                      return null;
                    },
                  ),
                ] else if (_mediaType == MediaType.video) ...[
                  Text(
                    '🎬 Upload & Edit Video',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  SizedBox(height: screenHeight * 0.0125),
                  VideoPlayerPreview(
                    onMediaUploaded: (url, mediaType) {
                      handleMediaUploaded(url);
                      _addMediaUrl(MediaType.video, url);
                    },
                  ),
                  SizedBox(height: screenHeight * 0.025),
                  Text(
                    'Add Text to Video',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: screenHeight * 0.0125),
                  // Add text-to-video editor
                  SizedBox(width: screenWidth * 0.04),
                  Text(
                    'Caption: What emotion or story does your video tell?',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Textfieldcreate(
                    controller: _videoCaptionController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText:
                          'Describe the emotion or story behind the video',
                    ),
                    text1: '',
                    text2: '',
                    prefix: Icon(null),
                    suffix: Icon(null),
                    obscureText: false,
                    validator: (String? value) {
                      return null;
                    },
                  ),
                ],
                SizedBox(height: screenHeight * 0.03),
                Text(
                  '📝 Title: My interpretation of "So it goes"',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                SizedBox(height: screenHeight * 0.01),
                Textfieldcreate(
                  controller: _mediaTitleController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter the title of your creation',
                  ),
                  text1: '',
                  text2: '',
                  prefix: Icon(null),
                  suffix: Icon(null),
                  obscureText: false,
                  validator: (String? value) {
                    return null;
                  },
                  minLines: 1,
                ),
                SizedBox(height: screenHeight * 0.025),
                Text(
                  '🧾 Description',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                SizedBox(height: screenHeight * 0.01),
                Textfieldcreate(
                  controller: _descriptionController,
                  minLines: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Provide a short description of your creation',
                  ),
                  text1: '',
                  text2: '',
                  prefix: Icon(null),
                  suffix: Icon(null),
                  obscureText: false,
                  validator: (String? value) {
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.025),
                Text(
                  '🏷 Tags',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                SizedBox(height: screenHeight * 0.01),
                Textfieldcreate(
                  controller: _tagsController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter tags like #Vonnegut #QuoteArt',
                  ),
                  text1: '',
                  text2: '',
                  prefix: Icon(null),
                  suffix: Icon(null),
                  obscureText: false,
                  validator: (String? value) {
                    return null;
                  },
                  minLines: 3,
                ),
              ],
            ),
          ),
        ),
      ),
      //-------step-----------------------

      //----------------------------------------
    ];
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: AppDrawer(menuItems: menuItems, user: _user),
      body: Stack(
        // Using Stack here for Positioning
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
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
                            Scaffold.of(context)
                                .openDrawer(); // ✅ Opens the drawer
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
                SizedBox(height: screenHeight * 0.025),
                Text(
                  'Be a LitMedia content creator',
                  style: TextStyle(
                    fontFamily: 'Newsreader',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    letterSpacing: 1.0,
                  ),
                ),
                SizedBox(height: screenHeight * 0.0125),
                // Other widgets you may want to add here...

                Container(
                  height: screenHeight,
                  width: screenWidth,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black, Colors.deepPurple],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Stepper(
                    type: StepperType.horizontal,
                    currentStep: currentStep,
                    onStepCancel: () {
                      setState(() {
                        if (currentStep > 0) {
                          currentStep -= 1; // Move to the previous step
                        }
                      });
                    },
                    onStepContinue: () {
                      if (currentStep < steps(context).length - 1) {
                        // Validate the current step before moving forward
                        if (currentStep == 0) {
                          if (_formKey1.currentState?.validate() ?? false) {
                            setState(() {
                              currentStep += 1; // Move to the next step
                            });
                          } else {
                            Fluttertoast.showToast(
                              msg:
                                  "Please fill out all required fields in Step 1",
                              backgroundColor: Colors.red,
                            );
                          }
                        } else if (currentStep == 1) {
                          if (_formKey2.currentState?.validate() ?? false) {
                            if (_mediaType == null) {
                              Fluttertoast.showToast(
                                msg:
                                    "Please select a media type before proceeding!",
                                backgroundColor: Colors.red,
                              );
                              return;
                            }
                            if (uploadedMediaUrls[_mediaType] == null) {
                              Fluttertoast.showToast(
                                msg:
                                    "Please upload a file for the selected media type: ${_mediaType!.name}",
                                backgroundColor: Colors.red,
                              );
                              return;
                            }
                            setState(() {
                              currentStep += 1; // Move to the next step
                            });
                          } else {
                            Fluttertoast.showToast(
                              msg:
                                  "Please fill out all required fields in Step 2",
                              backgroundColor: Colors.red,
                            );
                          }
                        }
                      } else if (currentStep == steps(context).length - 1) {
                        // If it's the last step, validate and submit
                        if (_mediaType == null) {
                          Fluttertoast.showToast(
                            msg:
                                "Please select a media type before submitting!",
                            backgroundColor: Colors.red,
                          );
                          return;
                        }
                        if (uploadedMediaUrls[_mediaType] == null) {
                          Fluttertoast.showToast(
                            msg:
                                "Please upload a file for the selected media type: ${_mediaType!.name}",
                            backgroundColor: Colors.red,
                          );
                          return;
                        }
                        if (_quoteBook.text.isEmpty &&
                            _searchController.text.isNotEmpty) {
                          _quoteBook.text = _searchController.text.trim();
                        }
                        saveMediaContent();
                      }
                    },
                    steps: steps(context),
                    controlsBuilder: (context, details) {
                      final isFirstStep = currentStep == 0;
                      final isLastStep =
                          currentStep == steps(context).length - 1;

                      return Padding(
                        padding: EdgeInsets.only(top: screenHeight * 0.025),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: details.onStepContinue,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isLastStep
                                      ? Colors.green.shade400
                                      : Colors.amber.shade400,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(isLastStep ? 'Finish' : 'Next'),
                              ),
                            ),
                            if (!isFirstStep) ...[
                              SizedBox(width: screenWidth * 0.04),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: details.onStepCancel,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey.shade300,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text('Back'),
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum MediaType { audio, image, video }
