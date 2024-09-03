import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/base.dart';

abstract class BaseRepository<T extends MappableModel> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final String basePath = 'ReadingAPP/Test';
  final String collection;
  final Duration timeout = const Duration(seconds: 10);
  String? get parentCollection;

  BaseRepository() : collection = T.toString();

  Stream<List<T>> stream([String? parentId]) {
    if (parentId == null) {
      return db.collection('$basePath/$collection')
              .snapshots()
              .map((snapshot) {
        return snapshot.docs.map((doc) => fromMap(doc.data(), doc.id)).toList();
      });
    } else {
      return db
          .collection('$basePath/$parentCollection')
          .doc(parentId)
          .collection(collection)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => fromMap(doc.data(), doc.id)).toList();
      });
    }
  }

  Stream<List<T>> streamOrderBy([String? parentId, String? orderBy]) {
    orderBy ??= "id";
    if (parentId == null) {
      return db.collection('$basePath/$collection')
              .orderBy(orderBy)
              .snapshots()
              .map((snapshot) {
        return snapshot.docs.map((doc) => fromMap(doc.data(), doc.id)).toList();
      });
    } else {
      return db
          .collection('$basePath/$parentCollection')
          .doc(parentId)
          .collection(collection)
          .orderBy(orderBy, descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => fromMap(doc.data(), doc.id)).toList();
      });
    }
  }

  Future<String> add(T item, [String? parentId]) async {
    Map<String, dynamic> itemMap = item.toMap();
    itemMap.remove('id');

    DocumentReference docRef;
    if (parentId == null) {
      docRef = await db
          .collection('$basePath/$collection')
          .add(itemMap)
          .timeout(timeout);
    } else {
      docRef = await db
          .collection('$basePath/$parentCollection')
          .doc(parentId)
          .collection(collection)
          .add(itemMap)
          .timeout(timeout);
    }

    return docRef.id;
  }

  Future<void> update(T item, String? itemId, [String? parentId]) async {
    Map<String, dynamic> itemMap = item.toMap();
    itemMap.remove('id');

    if (parentId == null) {
      await db
        .collection('$basePath/$collection')
        .doc(itemId)
        .set(itemMap)
        .timeout(timeout)
        .onError((e, _) => print("Error writing document: $e"));
    } else {
      await db
        .collection('$basePath/$parentCollection')
        .doc(parentId)
        .collection(collection)
        .doc(itemId)
        .set(itemMap)
        .onError((e, _) => print("Error writing document: $e"));
    }

  }

  Future<T?> get(String id, [String? parentId]) async {
    DocumentSnapshot docRef;
    if (parentId == null) {
      docRef = await db.collection('$basePath/$collection').doc(id).get();
    } else {
      docRef = await db
          .collection('$basePath/$parentCollection')
          .doc(parentId)
          .collection(collection)
          .doc(id)
          .get();
    }

    if (docRef.exists) {
      return fromMap(docRef.data() as Map<String, dynamic>, docRef.id);
    } else {
      return null;
    }
  }

  T fromMap(Map<String, dynamic> map, String id);
}
