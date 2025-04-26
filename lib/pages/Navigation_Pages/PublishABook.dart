import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:litmedia/pages/Navigation_Pages/homepage.dart';
import 'package:litmedia/pages/details/AddPic.dart';
import 'package:litmedia/pages/model/book.dart';
import 'package:litmedia/pages/service/database.dart';
import 'package:litmedia/static/colors.dart';
import 'package:litmedia/widget/custumDropDown.dart';
import 'package:litmedia/widget/textfieldcreate.dart';
import 'package:random_string/random_string.dart';
import 'package:rich_typewriter/rich_typewriter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:zo_animated_border/widget/zo_dotted_border.dart';

class MultiFormPage extends StatefulWidget {
  const MultiFormPage({super.key});

  @override
  State<MultiFormPage> createState() => _MultiFormPageState();
}

class _MultiFormPageState extends State<MultiFormPage> {
  int currentStep = 0;

  bool get isFirstStep => currentStep == 0;
  bool get isLastStep => currentStep == steps(context).length - 1;

  bool isComplete = false;

  String? selectedGenre;
  File? _bookCover;

  final List<String> genres = [
    'none',
    'Action/Adventure',
    'Biography/Autobiography',
    'Children\'s Fiction',
    'Classics',
    'Contemporary Fiction',
    'Crime/Thriller',
    'Detective/Mystery',
    'Fantasy',
    'Historical Fiction',
    'Horror',
    'Literary Fiction',
    'Magical Realism',
    'Memoir',
    'Non-Fiction',
    'Philosophy',
    'Poetry',
    'Psychology',
    'Romance',
    'Science Fiction',
    'Self-Help',
    'Spirituality/Religion',
    'Suspense',
    'Technology/Computers',
    'Thriller',
    'Travel',
    'Young Adult (YA)',
    'Science',
    'Adventure',
    'Historical Literature',
    'Military Fiction',
    'Arabic Culture',
    'True Crime',
    'Health & Wellness',
    'Cookbooks/Food',
    'Business & Economics',
    'Arts & Photography',
  ];

  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController authorController;
  late TextEditingController genreController;
  late TextEditingController descriptionController;

  late TextEditingController _publicationDateController;
  late TextEditingController _languageController; // lowercase 'L' in 'language'
  late TextEditingController _KeyWordsController;
  late TextEditingController _PubInfoController;
  late TextEditingController _PriceController;
  late TextEditingController _BookLenController;
  late TextEditingController _BookLinkController;
  late TextEditingController _SimilarBooksController;
  late TextEditingController _BookExcerptController;
  late TextEditingController _BookSeriesController;
  late TextEditingController _BookSeriesInfoController;

  // Define a variable to store the book cover URL

  String? _publishementType;
  final List<String> _pubTypes = ['Traditional Publishing', 'Self Publishing'];
  final List<String> _languages = [
    'Arabic',
    'French',
    'English',
  ]; // Fixed spelling of "French"

  String? _readingLevel = 'Beginner';
  String? _selectedLang;
  String? selectedGenre1;
  String? selectedGenre2;

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final DatabaseMethods _databaseService = DatabaseMethods();

  @override // ✅ Missing override
  void initState() {
    super.initState();

    _publicationDateController = TextEditingController();
    titleController = TextEditingController();
    authorController = TextEditingController();
    genreController = TextEditingController();
    descriptionController = TextEditingController();
    _publicationDateController = TextEditingController();
    _languageController = TextEditingController();
    _KeyWordsController = TextEditingController();
    _PubInfoController = TextEditingController();
    _PriceController = TextEditingController();
    _BookLenController = TextEditingController();
    _BookLinkController = TextEditingController();
    _SimilarBooksController = TextEditingController();
    _BookExcerptController = TextEditingController();
    _BookSeriesController = TextEditingController();
    _BookSeriesInfoController = TextEditingController();
    final String formattedDate = DateFormat(
      'yyyy-MM-dd',
    ).format(DateTime.now());
    _publicationDateController.text = formattedDate;
  }

  @override
  void dispose() {
    _publicationDateController.dispose();
    _languageController.dispose();
    _KeyWordsController.dispose();
    _PubInfoController.dispose();
    _PriceController.dispose();
    _BookLenController.dispose();
    _BookLinkController.dispose();
    _SimilarBooksController.dispose();
    _BookExcerptController.dispose();
    _BookSeriesController.dispose();
    _BookSeriesInfoController.dispose();
    super.dispose();
  }

  File? _imageFile;
  String? _uploadedImageUrl;

  Future<void> uploadToImageKit(File imageFile) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://upload.imagekit.io/api/v1/files/upload'),
    );

    request.files
        .add(await http.MultipartFile.fromPath('file', imageFile.path));
    request.fields['fileName'] = 'book_image.jpg';
    // change this
    String privateApiKey = 'private_9MoH0BcI0CyoI+15FSakzzoFSqs=';
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$privateApiKey:'));
    request.headers['Authorization'] = basicAuth;

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final imageUrl = data['url'];

      setState(() {
        _uploadedImageUrl = imageUrl;
      });

      print("Image uploaded and saved: $imageUrl");
    } else {
      print("Upload failed: ${response.statusCode}, ${response.body}");
      Fluttertoast.showToast(
        msg: "ImageKit upload failed: ${response.reasonPhrase}",
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> pickAndUploadImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      setState(() {
        _bookCover = file; // show locally
      });

      await uploadToImageKit(file); // upload to ImageKit
    } else {
      print("No image selected.");
      Fluttertoast.showToast(
        msg: "No image selected. Please choose a book cover.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF242038),
      body: Stepper(
        type: StepperType.horizontal,
        steps: steps(context),
        currentStep: currentStep,
        onStepContinue: () async {
          //here i can make the navigation to the other page

          if (currentStep == 0) {
            if (_formKey1.currentState!.validate()) {
              setState(() => currentStep += 1);
            } else {
              print("Form 1 is not valid");
            }
          } else if (currentStep == 1) {
            if (_formKey2.currentState!.validate()) {
              setState(() => currentStep += 1);
            } else {
              print("Form 2 is not valid");
            }
          } else if (isLastStep) {
            if (_formKey1.currentState!.validate() &&
                _formKey2.currentState!.validate()) {
              setState(() => isComplete = true);

              Future<void> pickImage() async {
                final picked =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                if (picked != null) {
                  setState(() => _imageFile = File(picked.path));
                  uploadToImageKit(File(picked.path));
                }
              }

              try {
                String Id = randomAlphaNumeric(10);

                // Save the book information to Firestore
                await FirebaseFirestore.instance
                    .collection('book')
                    .doc(Id)
                    .set({
                  'title': titleController.text,
                  'author': authorController.text,
                  'description': descriptionController.text,
                  'language': [_selectedLang]
                      .where((g) => g != null && g.trim().isNotEmpty)
                      .cast<String>()
                      .toList(),

                  'price': int.parse(_PriceController.text),
                  'bookLength': int.parse(_BookLenController.text),
                  'genres': [selectedGenre1, selectedGenre2]
                      .where((g) => g != null && g.trim().isNotEmpty)
                      .cast<String>()
                      .toList(),

                  'keywords': _KeyWordsController.text
                      .split(',')
                      .map((e) => e.trim())
                      .where((e) => e.isNotEmpty)
                      .toList(),
                  'publicationDate': Timestamp.fromDate(DateFormat('yyyy-MM-dd')
                      .parse(_publicationDateController.text)),

                  'bookSeries': _BookSeriesController.text
                      .split(',')
                      .map((e) => e.trim())
                      .where((e) => e.isNotEmpty)
                      .toList(),
                  'bookSeriesInfo': _BookSeriesInfoController.text.isNotEmpty
                      ? _BookSeriesInfoController.text
                      : null,
                  'bookLink': _BookLinkController.text.isNotEmpty
                      ? _BookLinkController.text
                      : null,
                  'bookExcerpt': _BookExcerptController.text.isNotEmpty
                      ? _BookExcerptController.text
                      : null,
                  'bookCover': _uploadedImageUrl,

                  // Save the book cover URL
                }).then((value) {
                  print("Book added successfully!");
                  Fluttertoast.showToast(
                    msg: "Book added successfully!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
// Define bookData as a Map and initialize it

                  // Navigate to the homepage
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Homepage(),
                    ),
                  );
                }).catchError((error) {
                  print("Failed to add book: $error");
                  Fluttertoast.showToast(
                    msg: "Failed to add book: $error",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                });
              } catch (error) {
                print("Failed to add book: $error");
                Fluttertoast.showToast(
                  msg: "Failed to add book: $error",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              }
            }
          }
        },
        onStepCancel:
            isFirstStep ? null : () => setState(() => currentStep -= 1),
        onStepTapped: (step) => setState(() => currentStep = step),
        controlsBuilder: (context, details) => Padding(
          padding: const EdgeInsets.only(top: 32),
          child: Row(
            children: [
              if (isFirstStep) ...[
                Expanded(
                  child: ZoDottedBorder(
                    animate: true,
                    borderRadius: 12,
                    dashLength: 10,
                    gapLength: 5,
                    strokeWidth: 3,
                    color: AppColors.electricPurple,
                    animationDuration: Duration(seconds: 4),
                    borderStyle: BorderStyleType.monochrome,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        setState(() => currentStep += 1);
                      },
                      child: Text(
                        isLastStep ? 'Publish Now' : 'Next',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ] else ...[
                Expanded(
                  child: ElevatedButton(
                    onPressed: details.onStepContinue,
                    child: Text(isLastStep ? 'Confirm' : 'Next'),
                  ),
                ),
                if (!isFirstStep) ...[
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: details.onStepCancel,
                      child: const Text('Back'),
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }

  List<Step> steps(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return [
      Step(
        state: currentStep > 0 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 0,
        title: Text(
          '1',
          style: TextStyle(fontSize: screenWidth * 0.04),
        ),
        content: Column(
          children: [
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height * 0.8,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: screenHeight * 0.05),
                        Container(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: double.infinity,
                            child: RichTypewriter(
                              symbolDelay: (span) => 100,
                              child: const Text.rich(
                                TextSpan(
                                  text: "    Ready to publish your book?",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontFamily: 'RozhaOne',
                                  ),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.1),
                        SizedBox(
                          width: screenWidth * 0.9,
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              'Have a literary voice the world needs to hear? From compelling essays to timeless poetry, sharp critiques to heartfelt fiction—Literature Media invites writers of every genre to bring their work to the public eye. Whether you seek to inform, inspire, or simply share your craft, now is the time to publish. Step into a space where literature thrives and voices matter.',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'RocknRollOne',
                                fontSize: screenWidth * 0.04,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.1),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      Step(
        title: Text(
          '2',
          style:
              TextStyle(fontSize: screenWidth * 0.04), // Responsive font size
        ),
        content: SingleChildScrollView(
          child: Container(
            color: const Color.fromARGB(255, 167, 160, 176),
            width: double.infinity,
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: screenWidth * 0.9),
                child: Form(
                  key: _formKey2,
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.03),

                      // Book Cover Upload Section
                      GestureDetector(
                        onTap: pickAndUploadImage,
                        child: Container(
                          width: screenWidth * 0.4, // Responsive width
                          height: screenHeight * 0.25, // Responsive height
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: const Color.fromARGB(255, 248, 247, 255),
                              width: 2,
                            ),
                            image: _bookCover != null
                                ? DecorationImage(
                                    image: FileImage(_bookCover!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: _bookCover == null
                              ? Center(
                                  child: Text(
                                    'Upload Cover',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: screenWidth *
                                          0.04, // Responsive font size
                                    ),
                                  ),
                                )
                              : null,
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.03),

                      // Title Input
                      SizedBox(
                        width: screenWidth * 0.9,
                        child: Textfieldcreate(
                          text1: 'Book Title',
                          text2: 'Ex: ',
                          prefix: Icon(Icons.title),
                          suffix: Icon(null),
                          obscureText: false,
                          controller: titleController,
                          decoration: _inputDecoration('Book Title'),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Enter title'
                              : null,
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.03),

                      // Author Input
                      SizedBox(
                        width: screenWidth * 0.9,
                        child: Textfieldcreate(
                          text1: 'Author Name',
                          text2: 'Ex: Mohammed Dib',
                          prefix: Icon(Icons.person),
                          suffix: Icon(null),
                          obscureText: false,
                          controller: authorController,
                          decoration: _inputDecoration('Author Name'),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Enter author'
                              : null,
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.03),

                      // Genre Selection
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: screenWidth * 0.03),
                        child: Text(
                          'Select a Genre',
                          style: TextStyle(fontSize: screenWidth * 0.045),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.01),
                      SizedBox(
                        height: screenHeight * 0.1,
                        width: screenWidth * 0.9,
                        child: _buildDropdown(
                          hint: 'Select Genre',
                          selectedValue: selectedGenre1,
                          onChanged: (value) {
                            setState(() {
                              selectedGenre1 = value;
                            });
                          },
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.02),

                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: screenWidth * 0.03),
                        child: Text(
                          'Select a second Genre',
                          style: TextStyle(fontSize: screenWidth * 0.045),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.01),
                      SizedBox(
                        height: screenHeight * 0.1,
                        width: screenWidth * 0.9,
                        child: _buildDropdown(
                          hint: 'Select Second Genre',
                          selectedValue: selectedGenre2,
                          onChanged: (value) {
                            setState(() {
                              selectedGenre2 = value;
                            });
                          },
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.02),

                      // Description
                      SizedBox(
                        width: screenWidth * 0.9,
                        child: _buildMultilineField(
                          descriptionController,
                          'Book Description',
                          5,
                          1000,
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.02),

                      // Target Audience
                      SizedBox(
                        width: screenWidth * 0.9,
                        child: _buildMultilineField(
                          null,
                          'Target Audience',
                          3,
                          500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),

      /* Step(


        title: Text(
          '2',
          style: TextStyle(fontSize: screenWidth * 0.04),
        ),
        content: Column(
          children: [
            SingleChildScrollView(
              child: Container(
                color: const Color.fromARGB(255, 167, 160, 176),
                width: double.infinity,
                height: screenHeight * 1.5,
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: screenWidth * 0.9),
                    child: Form(
                      key: _formKey2,
                      child: Column(
                        children: [
                          SizedBox(height: screenHeight * 0.03),

                          // Book Cover Upload Section
                          GestureDetector(
                            onTap: _pickCoverImage,
                            child: Container(
                              width: screenWidth * 0.4, // Responsive width
                              height: screenHeight * 0.25,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 248, 247, 255),
                                  width: 2,
                                ),
                                image: _bookCover != null
                                    ? DecorationImage(
                                        image: FileImage(_bookCover!),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: _bookCover == null
                                  ? Center(
                                      child: Text(
                                        'Upload Cover',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: screenWidth * 0.04,
                                        ),
                                      ),
                                    )
                                  : null,
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.03),

                          // Title Input
                          SizedBox(
                            height: screenHeight * 0.1,
                            width: screenWidth * 0.9,
                            child: Textfieldcreate(
                              text1: 'Book Title',
                              text2: 'Ex : ',
                              prefix: Icon(Icons.title),
                              suffix: Icon(null),
                              obscureText: false,
                              controller: titleController,
                              decoration: _inputDecoration('Book Title'),
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Enter title'
                                      : null,
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.03),

                          // Author Input
                          SizedBox(
                            height: screenHeight * 0.1,
                            width: screenWidth * 0.9,
                            child: Textfieldcreate(
                              text1: 'Author Name',
                              text2: 'Ex : Mohammed Dib',
                              prefix: Icon(Icons.person),
                              suffix: Icon(null),
                              obscureText: false,
                              controller: authorController,
                              decoration: _inputDecoration('Author Name'),
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Enter author'
                                      : null,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.03),

                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 14),
                            child: Text(
                              'Select a Genre',
                              style: TextStyle(fontSize: screenWidth * 0.045),
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.01),
                          // First Genre Dropdown
                          SizedBox(
                            height: screenHeight * 0.1,
                            width: screenWidth * 0.9,
                            child: _buildDropdown(
                                hint: 'Select Genre',
                                selectedValue: selectedGenre1,
                                onChanged: (value) {
                                  setState(() {
                                    selectedGenre1 = value;
                                  });
                                }),
                          ),
                          SizedBox(height: screenHeight * 0.02),

                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 14),
                            child: Text(
                              'Select a second Genre',
                              style: TextStyle(fontSize: 16),
                            ),
                          ), // Second Genre Dropdown
                          SizedBox(height: screenHeight * 0.01),
                          SizedBox(
                            height: screenHeight * 0.1,
                            width: screenWidth * 0.9,
                            child: _buildDropdown(
                                hint: 'Select Second Genre',
                                selectedValue: selectedGenre2,
                                onChanged: (value) {
                                  setState(() {
                                    selectedGenre2 = value;
                                  });
                                }),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          // Description
                          SizedBox(
                            width: screenWidth * 0.9,
                            child: _buildMultilineField(
                              descriptionController,
                              'Book Description',
                              5,
                              1000,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),

                          // Target audience
                          SizedBox(
                            width: screenWidth * 0.9,
                            child: _buildMultilineField(
                              null,
                              'Target Audience',
                              3,
                              500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ), // Set width to fill the available space
            ),
          ],
        ),
      ),

*/

/*

      Step(
        state: currentStep > 0 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 2,
        title: Text(
          'Complete',
          style: TextStyle(fontSize: screenWidth * 0.04),
        ),
        content: Column(
          children: [
            SingleChildScrollView(
              child: Container(
                color: const Color.fromARGB(255, 167, 160, 176),
                width: double.infinity,
                height: screenHeight * 2,
                child: Form(
                  key: _formKey1,
                  child: Column(
                    children: [
                      SizedBox(height: 80),
                      SizedBox(
                        height: screenHeight * 0.2,
                        width: screenWidth * 0.9,
                        child: Textfieldcreate(
                          text1: 'Keywords', // Just example text
                          text2: '',
                          prefix: Icon(Icons.tag),
                          suffix: Icon(null),
                          obscureText: false,
                          controller: _KeyWordsController,
                          minLines: 3,

                          decoration: _inputDecoration('Keywords/Tags'),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Enter keywords'
                              : null,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 18),
                        child: Text(
                          'Select Language',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      SizedBox(
                        height: screenHeight * 0.1,
                        width: screenWidth * 0.9,
                        child: _buildDropdownLang(
                            hint: 'Select Language',
                            selectedValue: _selectedLang,
                            onChanged: (value) {
                              setState(() {
                                _selectedLang = value;
                              });
                            }),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      TextFormField(
                        controller: _publicationDateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Publication Date',
                        ),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _publicationDateController.text =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                            });
                          }
                        },
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      DropdownButtonFormField<String>(
                        value: _publishementType,
                        decoration: InputDecoration(
                          labelText: 'Publishement Type',
                        ),
                        items: _pubTypes.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _publishementType = val;
                          });
                        },
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      if (_publishementType == 'Traditional Publishing') ...[
                        SizedBox(
                          height: screenHeight * 0.1,
                          width: screenWidth * 0.9,
                          child: Textfieldcreate(
                            text1: 'Publisher info', // Just example text
                            text2: '',
                            prefix: Icon(Icons.tag),
                            suffix: Icon(null),
                            obscureText: false,

                            controller: _PubInfoController,
                            decoration: _inputDecoration('Publisher info'),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Enter Publisher'
                                : null,
                          ),
                        ),
                      ],
                      SizedBox(
                        height: screenHeight * 0.1,
                        width: screenWidth * 0.9,
                        child: Textfieldcreate(
                          text1: 'Price', // You can customize this label
                          text2:
                              '', // Optional second text (if not used, keep empty)
                          prefix: Icon(
                            Icons.attach_money,
                          ), // You can change this icon if needed
                          suffix: Icon(
                            null,
                          ), // Add a suffix icon or widget if required
                          obscureText:
                              false, // Since it's a price, no need to obscure the text
                          controller: _PriceController,
                          keyboardType: TextInputType.number,

                          decoration: _inputDecoration('Price'),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Enter price'
                              : null,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      SizedBox(
                        height: screenHeight * 0.1,
                        width: screenWidth * 0.9,
                        child: Textfieldcreate(
                          text1: 'Book Length', // Label or heading text
                          text2: '',
                          keyboardType: TextInputType.number,
                          // Optional subtext or hint, you can customize it
                          prefix: Icon(
                            Icons.menu_book_outlined,
                          ), // Optional, use any relevant icon
                          suffix: Icon(
                            null,
                          ), // Add a suffix widget if needed (like unit: pages)
                          obscureText: false, // No need to obscure this field
                          controller: _BookLenController,
                          decoration: _inputDecoration('Book Length'),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Enter book length'
                              : null,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 14),
                            child: Text(
                              'Reading Level',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          ListTile(
                            title: Text('Beginner'),
                            leading: Radio<String>(
                              value: 'Beginner',
                              groupValue: _readingLevel,
                              onChanged: (value) {
                                setState(() {
                                  _readingLevel = value;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: Text('Intermediate'),
                            leading: Radio<String>(
                              value: 'Intermediate',
                              groupValue: _readingLevel,
                              onChanged: (value) {
                                setState(() {
                                  _readingLevel = value;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: Text('Advanced'),
                            leading: Radio<String>(
                              value: 'Advanced',
                              groupValue: _readingLevel,
                              onChanged: (value) {
                                setState(() {
                                  _readingLevel = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      SizedBox(
                        height: screenHeight * 0.1,
                        width: screenWidth * 0.9,
                        child: Textfieldcreate(
                          text1: 'Book Excerpt', // Main label
                          text2: '', // Optional sublabel or hint text
                          prefix: Icon(
                            Icons.notes,
                          ), // Icon that fits the idea of an excerpt
                          suffix: Icon(
                            null,
                          ), // Optional, add something like character count if needed
                          obscureText:
                              false, // No need to hide text in an excerpt field
                          controller:
                              _BookExcerptController, // <-- Consider renaming this to _BookExcerptController
                          decoration: _inputDecoration('Book Excerpt'),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Enter book excerpt'
                              : null,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      SizedBox(
                        height: screenHeight * 0.1,
                        width: screenWidth * 0.9,
                        child: Textfieldcreate(
                          text1: 'Book Series',
                          text2: '', // Optional sublabel or hint
                          prefix: Icon(
                            Icons.collections_bookmark,
                          ), // Suitable icon for a series
                          suffix: Icon(
                            null,
                          ), // Optional: maybe an info icon if needed
                          obscureText: false, // No need to obscure
                          controller:
                              _BookSeriesController, // Consider renaming this to _BookSeriesController
                          decoration: _inputDecoration('Book Series'),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Enter book series'
                              : null,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      SizedBox(
                        height: screenHeight * 0.1,
                        width: screenWidth * 0.9,
                        child: Textfieldcreate(
                          text1: 'Book Series Info',
                          text2: '', // Optional sublabel or description
                          prefix: Icon(
                            Icons.info_outline,
                          ), // Info icon suits this label
                          suffix:
                              Icon(null), // Optional: add something if needed
                          obscureText: false,
                          controller: _BookSeriesInfoController,
                          minLines:
                              2, // Suggestion: rename to _BookSeriesInfoController
                          decoration: _inputDecoration('Book Series Info'),
                          validator: (value) => null,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      SizedBox(
                        height: screenHeight * 0.1,
                        width: screenWidth * 0.9,
                        child: Textfieldcreate(
                          text1: 'Similar Books',
                          text2: 'Enter titles separated by commas',
                          prefix: Icon(Icons.book_outlined),
                          suffix: Icon(null),
                          obscureText: false,
                          controller:
                              _SimilarBooksController, // Consider creating this controller separately
                          decoration: _inputDecoration(
                            'Similar Books (comma-separated)',
                          ),
                          minLines: 2,
                          validator: (value) => null,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      SizedBox(
                        height: screenHeight * 0.1,
                        width: screenWidth * 0.9,
                        child: Textfieldcreate(
                          text1: 'Book Website or Social Media',
                          text2: 'Enter a valid URL or handle',
                          prefix: Icon(Icons.link),
                          suffix: Icon(null),
                          obscureText: false,
                          controller:
                              _BookLinkController, // Consider renaming from _BookLenController
                          decoration: _inputDecoration(
                            'Book Website or Social Media Link',
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Enter the book website or social media link'
                              : null,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      FileUploadForm(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),*/

      Step(
        state: currentStep > 0 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 2,
        title: Text(
          'Complete',
          style:
              TextStyle(fontSize: screenWidth * 0.04), // Responsive font size
        ),
        content: SingleChildScrollView(
          child: Container(
            color: const Color.fromARGB(255, 167, 160, 176),
            width: double.infinity,
            child: Form(
              key: _formKey1,
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.03),

                  // Keywords Input
                  SizedBox(
                    height: screenHeight * 0.2,
                    width: screenWidth * 0.9,
                    child: Textfieldcreate(
                      text1: 'Keywords',
                      text2: '',
                      prefix: Icon(Icons.tag),
                      suffix: Icon(null),
                      obscureText: false,
                      controller: _KeyWordsController,
                      minLines: 3,
                      decoration: _inputDecoration('Keywords/Tags'),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Enter keywords'
                          : null,
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.03),

                  // Language Dropdown
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: screenWidth * 0.03),
                    child: Text(
                      'Select Language',
                      style: TextStyle(fontSize: screenWidth * 0.045),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  SizedBox(
                    height: screenHeight * 0.1,
                    width: screenWidth * 0.9,
                    child: _buildDropdownLang(
                      hint: 'Select Language',
                      selectedValue: _selectedLang,
                      onChanged: (value) {
                        setState(() {
                          _selectedLang = value;
                        });
                      },
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.03),

                  // Publication Date Picker
                  TextFormField(
                    controller: _publicationDateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Publication Date',
                      border: OutlineInputBorder(),
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _publicationDateController.text =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                        });
                      }
                    },
                  ),

                  SizedBox(height: screenHeight * 0.03),

                  // Publishement Type Dropdown
                  DropdownButtonFormField<String>(
                    value: _publishementType,
                    decoration: InputDecoration(
                      labelText: 'Publishement Type',
                      border: OutlineInputBorder(),
                    ),
                    items: _pubTypes.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _publishementType = val;
                      });
                    },
                  ),

                  SizedBox(height: screenHeight * 0.03),

                  // Publisher Info (Conditional)
                  if (_publishementType == 'Traditional Publishing') ...[
                    SizedBox(
                      width: screenWidth * 0.9,
                      child: Textfieldcreate(
                        text1: 'Publisher Info',
                        text2: '',
                        prefix: Icon(Icons.info),
                        suffix: Icon(null),
                        obscureText: false,
                        controller: _PubInfoController,
                        decoration: _inputDecoration('Publisher Info'),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Enter Publisher Info'
                            : null,
                      ),
                    ),
                  ],

                  SizedBox(height: screenHeight * 0.03),

                  // Price Input
                  SizedBox(
                    width: screenWidth * 0.9,
                    child: Textfieldcreate(
                      text1: 'Price',
                      text2: '',
                      prefix: Icon(Icons.attach_money),
                      suffix: Icon(null),
                      obscureText: false,
                      controller: _PriceController,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration('Price'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Enter price' : null,
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.03),

                  // Book Length Input
                  SizedBox(
                    width: screenWidth * 0.9,
                    child: Textfieldcreate(
                      text1: 'Book Length',
                      text2: '',
                      prefix: Icon(Icons.menu_book_outlined),
                      suffix: Icon(null),
                      obscureText: false,
                      controller: _BookLenController,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration('Book Length'),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Enter book length'
                          : null,
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.03),

                  // Reading Level Radio Buttons
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: screenWidth * 0.03),
                    child: Text(
                      'Reading Level',
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text('Beginner'),
                    leading: Radio<String>(
                      value: 'Beginner',
                      groupValue: _readingLevel,
                      onChanged: (value) {
                        setState(() {
                          _readingLevel = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('Intermediate'),
                    leading: Radio<String>(
                      value: 'Intermediate',
                      groupValue: _readingLevel,
                      onChanged: (value) {
                        setState(() {
                          _readingLevel = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('Advanced'),
                    leading: Radio<String>(
                      value: 'Advanced',
                      groupValue: _readingLevel,
                      onChanged: (value) {
                        setState(() {
                          _readingLevel = value;
                        });
                      },
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.03),

                  // Book Excerpt Input
                  SizedBox(
                    width: screenWidth * 0.9,
                    child: Textfieldcreate(
                      text1: 'Book Excerpt',
                      text2: '',
                      prefix: Icon(Icons.notes),
                      suffix: Icon(null),
                      obscureText: false,
                      controller: _BookExcerptController,
                      decoration: _inputDecoration('Book Excerpt'),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Enter book excerpt'
                          : null,
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.03),

                  // Similar Books Input
                  SizedBox(
                    width: screenWidth * 0.9,
                    child: Textfieldcreate(
                      text1: 'Similar Books',
                      text2: 'Enter titles separated by commas',
                      prefix: Icon(Icons.book_outlined),
                      suffix: Icon(null),
                      obscureText: false,
                      controller: _SimilarBooksController,
                      decoration: _inputDecoration('Similar Books'),
                      validator: (value) => null,
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.03),

                  // Book Website or Social Media Link
                  SizedBox(
                    width: screenWidth * 0.9,
                    child: Textfieldcreate(
                      text1: 'Book Website or Social Media',
                      text2: 'Enter a valid URL or handle',
                      prefix: Icon(Icons.link),
                      suffix: Icon(null),
                      obscureText: false,
                      controller: _BookLinkController,
                      decoration:
                          _inputDecoration('Book Website or Social Media Link'),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Enter the book website or social media link'
                          : null,
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.03),

                  // File Upload Form
                  FileUploadForm(),
                  SizedBox(height: screenHeight * 0.03),
                ],
              ),
            ),
          ),
        ),
      ),
    ];
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: AppColors.vibrantBlue, width: 3),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: AppColors.vibrantBlue, width: 3),
      ),
      filled: true,
      fillColor: const Color(0xFFF7ECE1),
    );
  }

  Widget buildTextField(String label, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          hintText: label == 'Book Excerpt'
              ? 'e.g., A powerful paragraph or quote from your book...'
              : null,
          border: OutlineInputBorder(),
        ),
        maxLines: maxLines,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildMultilineField(
    TextEditingController? controller,
    String label,
    int minLines,
    int maxLength,
  ) {
    return Textfieldcreate(
      text1: label, // Use the label as the main text
      text2: 'Enter your $label here', // Optional hint text
      prefix: Icon(Icons.edit), // You can customize the prefix icon
      suffix: Icon(null), // You can add a suffix if needed
      obscureText: false, // Set to true if you want to obscure text
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label'; // Custom validation message
        }
        return null; // Return null if validation passes
      },
      keyboardType: TextInputType.multiline, // Set keyboard type for multiline
      minLines: minLines, // Set minimum lines
      maxLength: maxLength,
      decoration: InputDecoration(), // Set maximum length
    );
  }

  Widget _buildDropdown(
      {required String hint,
      String? selectedValue,
      required Null Function(dynamic value) onChanged}) {
    return SizedBox(
      height: 90,
      width: 340,
      child: CustomDropdown<String>(
        value: selectedValue, // The currently selected value
        items: genres.map((genre) {
          return DropdownMenuItem<String>(value: genre, child: Text(genre));
        }).toList(),
        hintText: hint,
        onChanged: onChanged,

        validator: (value) => value == null ? 'Please select a genre' : null,
        prefixIcon: Icon(Icons.category), // Optional prefix icon
        suffixIcon: null, // Optional suffix icon
      ),
    );
  }

  Widget _buildDropdownLang(
      {required String hint,
      String? selectedValue,
      required Null Function(dynamic value) onChanged}) {
    return SizedBox(
      height: 90,
      width: 340,
      child: CustomDropdown<String>(
        value: selectedValue, // The currently selected value
        items: _languages.map((_languages) {
          return DropdownMenuItem<String>(
              value: _languages, child: Text(_languages));
        }).toList(),
        hintText: hint,
        onChanged: onChanged,

        validator: (value) => value == null ? 'Please select a Language' : null,
        prefixIcon: Icon(Icons.language), // Optional prefix icon
        suffixIcon: null, // Optional suffix icon
      ),
    );
  }
}
