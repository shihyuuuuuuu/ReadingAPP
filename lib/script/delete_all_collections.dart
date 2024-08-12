import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  /*
   WARNING!!!
   This script will delete ALL listed collections in the Firestore.
   This script will delete ALL listed collections in the Firestore.
   This script will delete ALL listed collections in the Firestore.
   */
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final FirebaseFirestore db = FirebaseFirestore.instance;

  for (var c in ['User', 'UserBook', 'ReadingSession', 'Note', 'Book']) {
    var collection = db.collection(c);
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }
}
