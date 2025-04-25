import 'package:cloud_firestore/cloud_firestore.dart';

class book {
  String Id;
  String title;
  String author;
  String? PubInfo;
  String description;
  String Language;
  int BookLen;
  List<String> Genre;
  int Price;
  List<String> SimBooks;
  String BookExcert;
  List<String> keywords;
  Timestamp pubDate;
  String? BookSeries;
  String? BookSeriesInfo;
  String? BookLink;
  String? BookCoverImageUrl;

  book({
    required this.Id,
    required this.title,
    required this.author,
    this.PubInfo,
    required this.description,
    required this.Language,
    required this.BookLen,
    required this.Genre,
    required this.Price,
    required this.SimBooks,
    required this.BookExcert,
    required this.keywords,
    required this.pubDate,
    this.BookSeries,
    this.BookSeriesInfo,
    this.BookLink,
    this.BookCoverImageUrl,
  });

  // Factory constructor to create a book object from Firestore JSON
  factory book.fromJson(Map<String, dynamic> json) {
    return book(
      Id: json['Id'],
      title: json['title'],
      author: json['author'],
      PubInfo: json['PubInfo'],
      description: json['description'],
      Language: json['Language'],
      BookLen: json['BookLen'],
      Genre: List<String>.from(json['Genre']),
      Price: json['Price'],
      SimBooks: List<String>.from(json['SimBooks']),
      BookExcert: json['BookExcert'],
      keywords: List<String>.from(json['keywords']),
      pubDate: json['pubDate'] is Timestamp
          ? json['pubDate']
          : Timestamp.fromMillisecondsSinceEpoch(json['pubDate']),
      BookSeries: json['BookSeries'],
      BookSeriesInfo: json['BookSeriesInfo'],
      BookLink: json['BookLink'],
      BookCoverImageUrl: json['BookCover'],
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
    };
  }

  // Method to create a copy of the book object with updated fields
  book copyWith({
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
    return book(
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
    );
  }
}
