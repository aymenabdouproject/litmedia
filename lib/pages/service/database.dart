import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:litmedia/pages/model/book.dart';

const String bookCollection = 'book';

class DatabaseMethods {
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference _bookRef;

  DatabaseMethods() {
    _bookRef = _firestore.collection(bookCollection).withConverter<book>(
          fromFirestore: (snapshots, _) => book.fromJson(
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

  void updateBook(String id, Map<String, dynamic> updatedFields) async {
    print("Updating book with ID: $id and data: $updatedFields");
    _bookRef.doc(id).update(updatedFields).then((value) {
      print("Book updated successfully!");
    }).catchError((error) {
      print("Failed to update book: $error");
    });
  }
}
