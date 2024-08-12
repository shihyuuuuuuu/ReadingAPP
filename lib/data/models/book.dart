import 'base.dart';

class Book extends MappableModel {
  String? id;
  String title;
  String? subtitle;
  List<String> authors;
  String? publisher;
  DateTime? publishedDate;
  String? description;
  List<String>? categories;
  int? pageCount;
  String? coverImage;

  @override
  Book({
    this.id,
    required this.title,
    this.subtitle,
    required this.authors,
    this.publisher,
    this.publishedDate,
    this.description,
    this.categories,
    this.pageCount,
    this.coverImage,
  });

  @override
  Book._({
    required this.id,
    required this.title,
    this.subtitle,
    required this.authors,
    this.publisher,
    this.publishedDate,
    this.description,
    this.categories,
    this.pageCount,
    this.coverImage,
  });

  @override
  factory Book.fromMap(Map<String, dynamic> map, String? id) {
    return Book._(
      id: id,
      title: map['title'],
      subtitle: map['subtitle'],
      authors: List<String>.from(map['authors']),
      publisher: map['publisher'],
      publishedDate: DateTime.parse(map['publishedDate']),
      description: map['description'],
      categories: List<String>.from(map['categories']),
      pageCount: map['pageCount'],
      coverImage: map['coverImage'],
    );
  }

  @override
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
