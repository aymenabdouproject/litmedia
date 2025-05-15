import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:litmedia/pages/model/book.dart';

const String bookCollection = 'book';
const String userCollection = "user";

class DatabaseMethods {
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference _bookRef;

  DatabaseMethods() {
    _bookRef = _firestore.collection(bookCollection).withConverter<Book>(
          fromFirestore: (snapshots, _) => Book.fromJson(
            snapshots.data()!,
          ),
          toFirestore: (book, _) => book.toJson(),
        );
  }

  Stream<QuerySnapshot> getBooks() {
    return _bookRef.snapshots();
  }

  void addBooks(Map<String, dynamic> bookInfoMap, String id) async {
    print("Adding book with ID: $id and data: $bookInfoMap");
    _bookRef.doc(id).set(bookInfoMap).then((value) {
      print("Book added successfully!");
    }).catchError((error) {
      print("Failed to add book: $error");
    });
  }

  Future<void> updateBook(
      String bookId, Map<String, dynamic> updatedData) async {
    try {
      await _firestore.collection('book').doc(bookId).update(updatedData);
      print("Book updated successfully!");
    } catch (e) {
      print("Failed to update the book: $e");
      throw Exception("Failed to update the book: $e");
    }
  }

  void deleteBook(String? id) async {
    try {
      print("Deleting book with ID: $id");
      await _bookRef.doc(id).delete();
      print("Book deleted successfully!");
    } catch (error) {
      print("Failed to delete book: $error");
    }
  }
}
