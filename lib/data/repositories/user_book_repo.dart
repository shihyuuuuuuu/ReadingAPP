import 'package:reading_app/data/models/user_book.dart';
import 'base_repo.dart';

class UserBookRepository extends BaseRepository<UserBook> {
  @override
  UserBook fromMap(Map<String, dynamic> map, String id) {
    return UserBook.fromMap(map, id);
  }

  @override
  String? parentCollection = 'User';
}
