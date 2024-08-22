import 'package:reading_app/data/models/user.dart';
import 'base_repo.dart';

class UserRepository extends BaseRepository<User> {
  @override
  User fromMap(Map<String, dynamic> map, String id) {
    return User.fromMap(map, id);
  }

  @override
  String? parentCollection;
}
