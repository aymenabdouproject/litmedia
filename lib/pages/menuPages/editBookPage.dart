import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:litmedia/pages/auth/auth_service.dart';
import 'package:litmedia/pages/bloc/book_bloc.dart';
import 'package:litmedia/pages/bloc/book_event.dart';
import 'package:http/http.dart' as http;
import 'package:litmedia/pages/model/book.dart';
import 'package:litmedia/pages/service/database.dart';
import 'package:litmedia/static/colors.dart';
import 'package:litmedia/widget/custumDropDown.dart';
import 'package:litmedia/widget/textfieldcreate.dart';

class EditBookPage extends StatefulWidget {
  final Book book;

  const EditBookPage({super.key, required this.book});

  @override
  State<EditBookPage> createState() => _EditBookPageState();
}

class _EditBookPageState extends State<EditBookPage> {
  late TextEditingController titleController;
  late TextEditingController authorController;
  late TextEditingController descriptionController;
  late TextEditingController publicationDateController;
  late TextEditingController languageController;
  late TextEditingController keywordsController;
  late TextEditingController pubInfoController;
  late TextEditingController priceController;
  late TextEditingController bookLenController;
  late TextEditingController bookLinkController;
  late TextEditingController similarBooksController;
  late TextEditingController bookExcerptController;
  late TextEditingController bookSeriesController;
  late TextEditingController bookSeriesInfoController;

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
  final List<String> _languages = [
    'Arabic',
    'French',
    'English',
  ];
  File? coverImage;
  String? _selectedLang;
  String? selectedGenre1;
  String? selectedGenre2;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.book.title ?? '');
    authorController = TextEditingController(text: widget.book.author ?? '');
    descriptionController =
        TextEditingController(text: widget.book.description ?? '');
    publicationDateController = TextEditingController(
      text: widget.book.pubDate != null
          ? DateFormat('yyyy-MM-dd').format(widget.book.pubDate!.toDate())
          : '',
    );
    languageController =
        TextEditingController(text: widget.book.Language ?? '');
    keywordsController = TextEditingController(
      text: widget.book.keywords?.join(', ') ?? '',
    );
    pubInfoController = TextEditingController(text: widget.book.PubInfo ?? '');
    priceController = TextEditingController(
      text: widget.book.Price != null ? widget.book.Price.toString() : '0',
    );
    bookLenController = TextEditingController(
      text: widget.book.BookLen != null ? widget.book.BookLen.toString() : '0',
    );
    bookLinkController =
        TextEditingController(text: widget.book.BookLink ?? '');
    similarBooksController = TextEditingController(
      text: widget.book.SimBooks?.join(', ') ?? '',
    );
    bookExcerptController =
        TextEditingController(text: widget.book.BookExcert ?? '');
    bookSeriesController =
        TextEditingController(text: widget.book.BookSeries ?? '');
    bookSeriesInfoController =
        TextEditingController(text: widget.book.BookSeriesInfo ?? '');
  }

  Future<bool> verifyUserPassword(String enteredPassword) async {
    try {
      // Get the currently logged-in user
      final User? currentUser = FirebaseAuth.instance.currentUser;

      // Ensure the user is logged in
      if (currentUser == null) {
        throw FirebaseAuthException(
          code: 'user-not-logged-in',
          message: 'No user is currently logged in.',
        );
      }

      // Retrieve the user's email
      final String? userEmail = currentUser.email;

      if (userEmail == null) {
        throw FirebaseAuthException(
          code: 'email-not-available',
          message: 'Email is not available for the current user.',
        );
      }

      // Create an EmailAuthCredential using the email and entered password
      final AuthCredential credential = EmailAuthProvider.credential(
        email: userEmail,
        password: enteredPassword,
      );

      // Re-authenticate the user with the credential
      await currentUser.reauthenticateWithCredential(credential);

      // If no exception is thrown, the password is correct
      return true;
    } catch (e) {
      // Handle specific Firebase exceptions if needed
      if (e is FirebaseAuthException) {
        if (e.code == 'wrong-password') {
          // Password is incorrect
          return false;
        }
      }

      // Re-throw the error for unexpected cases
      rethrow;
    }
  }

  void saveChanges() async {
    try {
      final updatedBook = Book(
        Id: widget.book.Id,
        title: titleController.text,
        author: authorController.text,
        description: descriptionController.text,
        Language: languageController.text,
        BookLen: int.tryParse(bookLenController.text) ?? widget.book.BookLen,
        Genre: widget.book.Genre,
        Price: int.tryParse(priceController.text) ?? widget.book.Price,
        SimBooks: similarBooksController.text
            .split(',')
            .map((e) => e.trim())
            .toList(),
        BookExcert: bookExcerptController.text,
        keywords:
            keywordsController.text.split(',').map((e) => e.trim()).toList(),
        pubDate: Timestamp.fromDate(
          DateFormat('yyyy-MM-dd').parse(publicationDateController.text),
        ),
        PubInfo: pubInfoController.text,
        BookLink: bookLinkController.text,
        BookSeries: bookSeriesController.text,
        BookSeriesInfo: bookSeriesInfoController.text,
        BookCoverImageUrl: _uploadedImageUrl ?? widget.book.BookCoverImageUrl,
        userId: widget.book.userId,
        ISBN: widget.book.ISBN,
      );

      await FirebaseFirestore.instance
          .collection('book')
          .doc(widget.book.Id)
          .update(updatedBook.toJson());

      Fluttertoast.showToast(
        msg: "Book saved successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      // Pass the updated book object back to the previous page
      Navigator.pop(context, updatedBook);
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to save book: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 167, 160, 176),
      appBar: AppBar(
        title: const Text('Edit Book'),
        backgroundColor: AppColors.lightPurple,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildImagePicker(),
              _buildInputField('Book Title', titleController),
              _buildInputField('Author Name', authorController),
              _buildMultilineField(descriptionController, 'Description', 6, 10),
              _buildDatePickerField(
                  'Publication Date', publicationDateController),
              _buildDropdownLang(
                hint: 'Select Language',
                selectedValue: _selectedLang,
                onChanged: (value) {
                  setState(() {
                    _selectedLang = value;
                  });
                },
              ),
              _buildDropdown(
                hint: 'Select Genre 1',
                selectedValue: selectedGenre1,
                onChanged: (value) {
                  setState(() {
                    selectedGenre1 = value;
                  });
                },
              ),
              _buildDropdown(
                hint: 'Select Genre 2',
                selectedValue: selectedGenre1,
                onChanged: (value) {
                  setState(() {
                    selectedGenre1 = value;
                  });
                },
              ),
              _buildInputField(
                  'Keywords (comma separated)', keywordsController),
              _buildInputField('Publication Info', pubInfoController),
              _buildInputField('Price', priceController),
              _buildInputField('Book Length', bookLenController),
              _buildInputField('Book Link', bookLinkController),
              _buildInputField(
                  'Similar Books (comma separated)', similarBooksController),
              _buildMultilineField(bookExcerptController, 'Excerpt', 3, 6),
              _buildInputField('Book Series', bookSeriesController),
              _buildMultilineField(
                  bookSeriesInfoController, 'Series Info', 2, 2),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: saveChanges,
                    icon: const Icon(Icons.save),
                    label: const Text('Save'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => confirmAndDeleteBook(context, widget.book),
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete'),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  File? _bookCover;
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
    String basicAuth = 'Basic ${base64Encode(utf8.encode('$privateApiKey:'))}';
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
        _bookCover = file; // Show the selected image locally
      });

      try {
        await uploadToImageKit(file); // Upload to ImageKit

        if (_uploadedImageUrl != null) {
          // Update the Firestore document with the new image URL
          await FirebaseFirestore.instance
              .collection('book')
              .doc(widget.book.Id) // Use the book's Firestore document ID
              .update({'bookCover': _uploadedImageUrl});

          Fluttertoast.showToast(
            msg: "Book cover updated successfully!",
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );

          // Optionally, update the local book object with the new image URL
          setState(() {
            widget.book.BookCoverImageUrl = _uploadedImageUrl;
          });
        } else {
          Fluttertoast.showToast(
            msg: "Failed to retrieve uploaded image URL.",
            backgroundColor: Colors.red,
          );
        }
      } catch (error) {
        Fluttertoast.showToast(
          msg: "Image upload failed: $error",
          backgroundColor: Colors.red,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: "No image selected. Please choose a book cover.",
        backgroundColor: Colors.red,
      );
    }
  }

  Widget _buildImagePicker() {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        pickAndUploadImage();
      },
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
                    fontSize: screenWidth * 0.04, // Responsive font size
                  ),
                ),
              )
            : null,
      ),
    );
  }

  void confirmAndDeleteBook(BuildContext context, Book book) {
    final TextEditingController passwordController = TextEditingController();

    // Step 1: Show confirmation dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this book?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close confirmation dialog

                // Step 2: Show password dialog
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Enter Your Password'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                              'Please enter your password to confirm deletion:'),
                          const SizedBox(height: 10),
                          TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final enteredPassword =
                                passwordController.text.trim();

                            if (enteredPassword.isNotEmpty) {
                              try {
                                bool isCorrect =
                                    await verifyUserPassword(enteredPassword);

                                if (isCorrect) {
                                  final DatabaseMethods databaseMethods =
                                      DatabaseMethods();
                                  databaseMethods.deleteBook(widget.book.Id);

                                  Navigator.of(context)
                                      .pop(); // Close password dialog
                                  Fluttertoast.showToast(
                                    msg: "Book deleted successfully.",
                                    backgroundColor:
                                        const Color.fromARGB(255, 29, 180, 119),
                                    textColor: Colors.white,
                                  );
                                  Navigator.pop(context); // Navigate back
                                } else {
                                  Fluttertoast.showToast(
                                    msg: "Password is incorrect.",
                                    backgroundColor: Colors.orange,
                                    textColor: Colors.white,
                                  );
                                }
                              } catch (e) {
                                Fluttertoast.showToast(
                                  msg: "An error occurred: $e",
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                );
                              }
                            } else {
                              Fluttertoast.showToast(
                                msg: "Password cannot be empty.",
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                              );
                            }
                          },
                          child: const Text('Confirm'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Yes, Delete'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDropdown({
    required String hint,
    String? selectedValue,
    required Null Function(dynamic value) onChanged,
  }) {
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
        items: _languages.map((languages) {
          return DropdownMenuItem<String>(
              value: languages, child: Text(languages));
        }).toList(),
        hintText: hint,
        onChanged: onChanged,

        validator: (value) => value == null ? 'Please select a Language' : null,
        prefixIcon: Icon(Icons.language), // Optional prefix icon
        suffixIcon: null, // Optional suffix icon
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Textfieldcreate(
        text1: label,
        text2: ' ',
        prefix: Icon(Icons.title),
        suffix: Icon(null),
        obscureText: false,
        controller: controller,
        validator: (value) =>
            value == null || value.isEmpty ? '$label is empty ' : null,
        decoration: InputDecoration(),
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

  Widget _buildDatePickerField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: TextField(
        controller: controller,
        readOnly: true,
        onTap: () async {
          final DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
          );
          if (pickedDate != null) {
            controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
          }
        },
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          suffixIcon: const Icon(Icons.calendar_today),
        ),
      ),
    );
  }
}
