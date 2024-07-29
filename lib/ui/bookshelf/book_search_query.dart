import 'package:reading_app/ui/bookshelf/book_state.dart';

class BookSearchQuery {
  String? queryString;
  Set<BookState> filter = <BookState>{};
}