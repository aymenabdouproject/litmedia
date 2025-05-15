import 'package:litmedia/pages/model/book.dart';

abstract class BookEvent {}

class LoadBooks extends BookEvent {
  final String userId;
  LoadBooks(this.userId);
}

class DeleteBook extends BookEvent {
  final String bookId;
  DeleteBook(this.bookId);
}

class UpdatedBook extends BookEvent {
  final Book book;
  UpdatedBook(this.book);
}
