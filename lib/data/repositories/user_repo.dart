import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reading_app/data/models/user.dart';

class UserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final timeout = const Duration(seconds: 10);

  Future<void> addUser(User user) async {
    Map<String, dynamic> userMap = user.toMap();
    // Remove 'id' because Firestore automatically generates a unique document ID for each new document added to the collection.
    userMap.remove('id');

    await _db.collection('users').add(userMap).timeout(timeout);
  }

  Future<User?> getUser(String name) async {
    try {
      QuerySnapshot querySnapshot = await _db
          .collection('users')
          .where('name', isEqualTo: name)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return null;
      } else {
        var doc = querySnapshot.docs.first;
        return User.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
    } catch (e) {
      return null;
    }
  }
}
