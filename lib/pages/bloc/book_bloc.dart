import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:litmedia/pages/bloc/book_event.dart';
import 'package:litmedia/pages/bloc/book_state.dart';
import 'package:litmedia/pages/model/book.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final FirebaseFirestore _firestore;

  BookBloc(this._firestore) : super(BookInitial()) {
    on<LoadBooks>(_onLoadBooks);
    on<DeleteBook>(_onDeleteBook);
    on<UpdatedBook>(_onUpdateBook);
  }

  Future<void> _onLoadBooks(LoadBooks event, Emitter<BookState> emit) async {
    emit(BookLoading());
    try {
      final snapshot = await _firestore
          .collection('book')
          .where('userId', isEqualTo: event.userId)
          .get();

      final books =
          snapshot.docs.map((doc) => Book.fromJson(doc.data())).toList();

      emit(BookLoaded(books));
    } catch (e) {
      emit(BookError('Failed to load books: $e'));
    }
  }

  Future<void> _onDeleteBook(DeleteBook event, Emitter<BookState> emit) async {
    try {
      await _firestore.collection('book').doc(event.bookId).delete();
      // Optionally reload books
    } catch (e) {
      emit(BookError('Failed to delete book: $e'));
    }
  }

  Future<void> _onUpdateBook(UpdatedBook event, Emitter<BookState> emit) async {
    try {
      await _firestore
          .collection('book')
          .doc(event.book.Id)
          .update(event.book.toJson());
    } catch (e) {
      emit(BookError('Failed to update book: $e'));
    }
  }
}
