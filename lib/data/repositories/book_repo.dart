import 'package:reading_app/data/models/book.dart';
import 'base_repo.dart';

class BookRepository extends BaseRepository<Book> {
  @override
  Book fromMap(Map<String, dynamic> map, String id) {
    return Book.fromMap(map, id);
  }
}
