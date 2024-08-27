import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reading_app/data/models/user.dart';
import 'base_repo.dart';

class UserRepository extends BaseRepository<User> {
  @override
  User fromMap(Map<String, dynamic> map, String id) {
    return User.fromMap(map, id);
  }

  Future<void> createUser(User item) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    Map<String, dynamic> itemMap = item.toMap();
    String id = itemMap['id'];
    itemMap.remove('id');

    await db
      .collection('ReadingAPP/Test/User')
      .doc(id)
      .set(itemMap);
  }

  Future<User?> getUserByEmail(String email) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    QuerySnapshot querySnapshot = await db
        .collection('ReadingAPP/Test/User')
        .where('email', isEqualTo: email)
        .get();
    if (querySnapshot.docs.isEmpty) {
      return null;
    }
    return User.fromMap(querySnapshot.docs.first.data() as Map<String, dynamic>,
        querySnapshot.docs.first.id);
  }

  @override
  String? parentCollection;
}
