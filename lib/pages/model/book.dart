import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  String? Id;
  String? ISBN;
  String? title;
  String? author;
  String? PubInfo;
  String? description;
  String? Language;
  int? BookLen;
  List<String>? Genre;
  int? Price;
  List<String>? SimBooks;
  String? BookExcert;
  List<String>? keywords;
  Timestamp? pubDate;
  String? BookSeries;
  String? BookSeriesInfo;
  String? BookLink;
  String? BookCoverImageUrl;
  String? userId;

  Book({
    this.Id,
    this.ISBN,
    this.title,
    this.author,
    this.PubInfo,
    this.description,
    this.Language,
    this.BookLen,
    this.Genre,
    this.Price,
    this.SimBooks,
    this.BookExcert,
    this.keywords,
    this.pubDate,
    this.BookSeries,
    this.BookSeriesInfo,
    this.BookLink,
    this.BookCoverImageUrl,
    required this.userId,
  });

  // Factory constructor to create a book object from Firestore JSON
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      Id: json['Id'] as String ?? '',
      title: json['title'] as String? ?? '', // Default to empty string
      author: json['author'] as String? ?? '',
      PubInfo: json['PubInfo'] as String?,
      description: json['description'] as String? ?? '',
      Language: json['Language'] as String? ?? '',
      BookLen: json['BookLen'] as int? ?? 0, // Default to 0
      Genre: json['Genre'] != null
          ? List<String>.from(json['Genre'] as List)
          : [], // Default to empty list
      Price: json['Price'] as int? ?? 0, // Default to 0
      SimBooks: json['SimBooks'] != null
          ? List<String>.from(json['SimBooks'] as List)
          : [], // Default to empty list
      BookExcert: json['BookExcert'] as String? ?? '',
      keywords: json['keywords'] != null
          ? List<String>.from(json['keywords'] as List)
          : [], // Default to empty list
      pubDate: json['pubDate'] is Timestamp
          ? json['pubDate'] as Timestamp?
          : null, // Leave as null if not present
      BookSeries: json['BookSeries'] as String?,
      BookSeriesInfo: json['BookSeriesInfo'] as String?,
      BookLink: json['BookLink'] as String?,
      BookCoverImageUrl: json['BookCover'] as String?,
      userId: json['uid'] as String? ?? '', ISBN: json['ISBN'] as String,
    );
  }
  // Method to convert a book object to Firestore JSON
  Map<String, dynamic> toJson() {
    return {
      'Id': Id,
      'title': title,
      'author': author,
      'PubInfo': PubInfo,
      'description': description,
      'Language': Language,
      'BookLen': BookLen,
      'Genre': Genre,
      'Price': Price,
      'SimBooks': SimBooks,
      'BookExcert': BookExcert,
      'keywords': keywords,
      'pubDate': pubDate,
      'BookSeries': BookSeries,
      'BookSeriesInfo': BookSeriesInfo,
      'BookLink': BookLink,
      'BookCover': BookCoverImageUrl,
      'uid': userId,
      'ISBN': ISBN
    };
  }

  static Book fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    if (data == null) {
      throw StateError('Missing data in Firestore document: ${snapshot.id}');
    }

    // Add the document ID if needed in your model
    data['Id'] = snapshot.id;

    return Book.fromJson(data);
  }

  static Map<String, dynamic> toFirestore(
    Book book,
    SetOptions? options,
  ) {
    return book.toJson();
  }

  // Method to create a copy of the book object with updated fields
  Book copyWith({
    String? Id,
    String? title,
    String? author,
    String? PubInfo,
    String? description,
    String? Language,
    int? BookLen,
    List<String>? Genre,
    int? Price,
    List<String>? SimBooks,
    String? BookExcert,
    List<String>? keywords,
    Timestamp? pubDate,
    String? BookSeries,
    String? BookSeriesInfo,
    String? BookLink,
    String? BookCoverImageUrl,
  }) {
    return Book(
        Id: Id ?? this.Id,
        title: title ?? this.title,
        author: author ?? this.author,
        PubInfo: PubInfo ?? this.PubInfo,
        description: description ?? this.description,
        Language: Language ?? this.Language,
        BookLen: BookLen ?? this.BookLen,
        Genre: Genre ?? this.Genre,
        Price: Price ?? this.Price,
        SimBooks: SimBooks ?? this.SimBooks,
        BookExcert: BookExcert ?? this.BookExcert,
        keywords: keywords ?? this.keywords,
        pubDate: pubDate ?? this.pubDate,
        BookSeries: BookSeries ?? this.BookSeries,
        BookSeriesInfo: BookSeriesInfo ?? this.BookSeriesInfo,
        BookLink: BookLink ?? this.BookLink,
        BookCoverImageUrl: BookCoverImageUrl ?? this.BookCoverImageUrl,
        userId: userId,
        ISBN: ISBN ?? this.ISBN);
  }
}
