import 'base.dart';
import '../local/book_state.dart';

class UserBook extends MappableModel {
  String? id;
  String userId;
  String bookId;
  BookState state;
  DateTime startDate;
  int currentPage;

  @override
  UserBook({
    this.id,
    required this.userId,
    required this.bookId,
    required this.state,
    required this.startDate,
    required this.currentPage,
  });

  @override
  UserBook._({
    required this.id,
    required this.userId,
    required this.bookId,
    required this.state,
    required this.startDate,
    required this.currentPage,
  });

  @override
  factory UserBook.fromMap(Map<String, dynamic> map, String? id) {
    return UserBook._(
      id: id,
      userId: map['userId'],
      bookId: map['bookId'],
      state: BookState.values.byName(map['state']),
      startDate: DateTime.parse(map['startDate']),
      currentPage: map['currentPage'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'bookId': bookId,
      'state': state.name,
      'startDate': startDate,
      'currentPage': currentPage,
    };
  }
}
