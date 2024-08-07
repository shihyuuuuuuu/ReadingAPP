import 'book_state.dart';

class UserBook {
  String id;
  String userId;
  String bookId;
  BookState state;
  DateTime startDate;
  int currentPage;

  UserBook({
    required this.id,
    required this.userId,
    required this.bookId,
    required this.state,
    required this.startDate,
    required this.currentPage,
  });

  factory UserBook.fromMap(Map<String, dynamic> map) {
    return UserBook(
      id: map['id'] as String,
      userId: map['userId'] as String,
      bookId: map['bookId'] as String,
      state: map['state'] as BookState,
      startDate: map['startDate'] as DateTime,
      currentPage: map['currentPage'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'bookId': bookId,
      'state': state,
      'startDate': startDate,
      'currentPage': currentPage,
    };
  }
}
