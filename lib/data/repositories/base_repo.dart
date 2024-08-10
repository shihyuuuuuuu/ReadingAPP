import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/base.dart';

abstract class BaseRepository<T extends MappableModel> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String collectionPath;
  final Duration timeout = const Duration(seconds: 10);

  BaseRepository() : collectionPath = T.toString();

  Future<String> add(T item) async {
    Map<String, dynamic> itemMap = item.toMap();
    itemMap.remove('id'); // Assuming `id` is managed by Firestore

    DocumentReference docRef = await _db.collection(collectionPath).add(itemMap).timeout(timeout);
    
    return docRef.id;
  }

  Future<T?> get(String id) async {
    try {
      QuerySnapshot querySnapshot = await _db
          .collection(collectionPath)
          .where('id', isEqualTo: id)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return null;
      } else {
        var doc = querySnapshot.docs.first;
        return fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
    } catch (e) {
      return null;
    }
  }

  T fromMap(Map<String, dynamic> map, String id);
}
