import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:litmedia/pages/menuPages/editBookPage.dart';
import 'package:litmedia/pages/model/book.dart';
import 'package:litmedia/widget/app_drawer.dart';
import 'package:litmedia/pages/service/database.dart';

class BookMan extends StatefulWidget {
  const BookMan({super.key});

  @override
  State<BookMan> createState() => _BookManState();
}

class _BookManState extends State<BookMan> {
  late TextEditingController searchController;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Stream<QuerySnapshot> getBooksStream() {
    if (searchQuery.isEmpty) {
      return FirebaseFirestore.instance.collection('book').snapshots();
    }
    return FirebaseFirestore.instance
        .collection('book')
        .where('title', isGreaterThanOrEqualTo: searchQuery)
        .where('title', isLessThanOrEqualTo: searchQuery + '\uf8ff')
        .snapshots();
  }

  void navigateToEdit(Book book) async {
    final updatedBook = await Navigator.push<Book?>(
      context,
      MaterialPageRoute(builder: (context) => EditBookPage(book: book)),
    );

    if (updatedBook != null) {
      print('Book updated: ${updatedBook.title}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(menuItems: [], user: null),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              onChanged: (query) {
                setState(() {
                  searchQuery = query.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: "Search by title or author",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: getBooksStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("No books found."),
                  );
                }

                final books = snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return {
                    'title': data['title'] ?? 'No Title',
                    'author': data['author'] ?? 'Unknown Author',
                    'ISBN': data['ISBN'] ?? 'No ISBN',
                  };
                }).toList();

                return ListView.builder(
                  itemCount: books.length,
                  padding: const EdgeInsets.all(12),
                  itemBuilder: (context, index) {
                    final book = books[index];
                    final bookData = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;

                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(book['title'] ?? 'No Title'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "Author: ${book['author'] ?? 'Unknown Author'}"),
                            Text("ISBN: ${book['ISBN'] ?? 'No ISBN'}"),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.black54,
                              ),
                              onPressed: () {
                                final bookObject = Book.fromJson(bookData);
                                navigateToEdit(bookObject);
                              },
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
