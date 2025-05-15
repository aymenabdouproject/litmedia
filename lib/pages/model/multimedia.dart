class Multimedia {
  String booktitle;
  String? bookauthor;
  String quote;
  String mediaUrl;
  String? caption;
  String? mediatitle;
  String? desc;
  List<String>? tags;
  String bookId;
  String mediaType;
  String? createdBy;
  String? bookCoverUrl;

  String? category;

  Multimedia(
      {required this.booktitle,
      required this.quote,
      required this.mediaUrl,
      required this.bookId,
      required this.mediaType,
      this.bookauthor,
      this.caption,
      this.mediatitle,
      this.desc,
      this.tags,
      this.createdBy,
      this.bookCoverUrl,
      this.category});

  factory Multimedia.fromJson(Map<String, dynamic> json) {
    return Multimedia(
      booktitle: json['booktitle'],
      quote: json['quote'],
      mediaUrl: json['mediaUrl'],
      bookId: json['bookId'],
      caption: json['caption'],
      mediatitle: json['mediatitle'],
      desc: json['desc'],
      tags: (json['tags'] as List<dynamic>?)?.cast<String>(),
      mediaType: json['mediaType'],
      createdBy: json['createdBy'],
      bookauthor: json['bookauthor'],
      bookCoverUrl: json['bookCoverUrl'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'booktitle': booktitle,
      'bookId': bookId,
      'quote': quote,
      'mediaUrl': mediaUrl,
      'caption': caption,
      'mediatitle': mediatitle,
      'desc': desc,
      'mediaType': mediaType,
      'tags': tags,
      'createdBy': createdBy,
      "bookCoverUrl": bookCoverUrl,
      'bookauthor': bookauthor,
      'category': category
    };
  }

  Multimedia copyWith(
      {String? booktitle,
      String? quote,
      String? mediaUrl,
      String? caption,
      String? mediatitle,
      String? desc,
      List<String>? tags,
      String? mediaType,
      String? bookCoverUrl,
      String? bookauthor,
      String? category}) {
    return Multimedia(
        booktitle: booktitle ?? this.booktitle,
        quote: quote ?? this.quote,
        mediaUrl: mediaUrl ?? this.mediaUrl,
        bookId: bookId,
        mediaType: mediaType ?? this.mediaType,
        caption: caption ?? this.caption,
        mediatitle: mediatitle ?? this.mediatitle,
        desc: desc ?? this.desc,
        tags: tags ?? this.tags,
        bookCoverUrl: bookCoverUrl ?? this.bookCoverUrl,
        bookauthor: bookauthor ?? this.bookauthor,
        category: category ?? this.category);
  }
}
