import 'package:reading_app/pages/bookshelf/book_state.dart';

class BookSearchQuery {
  String? queryString;
  Set<BookState> filter = <BookState>{};
}