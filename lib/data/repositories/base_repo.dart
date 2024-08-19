import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/base.dart';

abstract class BaseRepository<T extends MappableModel> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final String basePath = 'ReadingAPP/test';
  final String collection;
  final Duration timeout = const Duration(seconds: 10);

  BaseRepository() : collection = T.toString();

  Stream<List<T>> stream(String parentId) {
    return db
        .collection('$basePath/$parentCollection')
        .doc(parentId)
        .collection(collection)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  Future<String> add(T item) async {
    Map<String, dynamic> itemMap = item.toMap();
    itemMap.remove('id'); // Assuming `id` is managed by Firestore

    DocumentReference docRef = await db
        .collection('$basePath/$collection')
        .add(itemMap)
        .timeout(timeout);

    return docRef.id;
  }

  Future<String> addChild(T item, String parentId) async {
    Map<String, dynamic> itemMap = item.toMap();
    itemMap.remove('id');

    DocumentReference docRef = await db
        .collection('$basePath/$parentCollection')
        .doc(parentId)
        .collection(collection)
        .add(itemMap)
        .timeout(timeout);

    return docRef.id;
  }

  Future<T?> get(String id) async {
    try {
      QuerySnapshot querySnapshot = await db
          .collection(collection)
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
  String parentCollection = ''; // Set this if it's not the root collection
}
