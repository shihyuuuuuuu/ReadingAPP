class Book {
  String id;
  String title;
  String subtitle;
  List<String> authors;
  String publisher;
  DateTime publishedDate;
  String description;
  List<String> categories;
  int pageCount;
  String coverImage;
  
  Book({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.authors,
    required this.publisher,
    required this.publishedDate,
    required this.description,
    required this.categories,
    required this.pageCount,
    required this.coverImage,
  });

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] as String,
      title: map['title'] as String,
      subtitle: map['subtitle'] as String,
      authors: List<String>.from(map['authors']),
      publisher: map['publisher'] as String,
      publishedDate: map['publishedDate'] as DateTime,
      description: map['description'] as String,
      categories: List<String>.from(map['categories']),
      pageCount: map['pageCount'] as int,
      coverImage: map['coverImage'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'authors': authors,
      'publisher': publisher,
      'publishedDate': publishedDate,
      'description': description,
      'categories': categories,
      'pageCount': pageCount,
      'coverImage': coverImage,
    };
  }
}
