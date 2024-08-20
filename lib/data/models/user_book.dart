import '../local/book_state.dart';
import 'base.dart';
import 'book.dart';

class UserBook extends MappableModel {
  String? id;
  String userId;
  Book book;
  BookState state;
  DateTime startDate;
  int currentPage;

  @override
  UserBook({
    this.id,
    required this.userId,
    required this.book,
    required this.state,
    required this.startDate,
    required this.currentPage,
  });

  @override
  UserBook._({
    required this.id,
    required this.userId,
    required this.book,
    required this.state,
    required this.startDate,
    required this.currentPage,
  });

  @override
  factory UserBook.fromMap(Map<String, dynamic> map, [String? id]) {
    return UserBook._(
      id: id,
      userId: map['userId'],
      book: Book.fromMap(map['book'], map['book']['id']),
      state: BookState.values.byName(map['state']),
      startDate: map['startDate'].toDate(),
      currentPage: map['currentPage'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'book': book.toMap(),
      'state': state.name,
      'startDate': startDate,
      'currentPage': currentPage,
    };
  }
}
