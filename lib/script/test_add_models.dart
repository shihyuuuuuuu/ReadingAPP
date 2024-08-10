import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:reading_app/data/models/book.dart';
import 'package:reading_app/data/models/note.dart';
import 'package:reading_app/data/models/reading_session.dart';
import 'package:reading_app/data/models/user.dart';
import 'package:reading_app/data/models/user_book.dart';
import 'package:reading_app/data/repositories/book_repo.dart';
import 'package:reading_app/data/repositories/note_repo.dart';
import 'package:reading_app/data/repositories/reading_session_repo.dart';
import 'package:reading_app/data/repositories/user_book_repo.dart';
import 'package:reading_app/data/repositories/user_repo.dart';

Future<Map<String, dynamic>> readJson() async {
  final String dataStr = await rootBundle.loadString('assets/test_data.json');
  final Map<String, dynamic> data = json.decode(dataStr);
  return data;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final Map<String, dynamic> testData = await readJson();

  final List<dynamic> users = testData['User'];
  final List<dynamic> books = testData['Book'];
  final List<dynamic> userBooks = testData['UserBook'];
  final List<dynamic> notes = testData['Note'];
  final List<dynamic> readingSessions = testData['ReadingSession'];

  final userRepository = UserRepository();
  final bookRepository = BookRepository();
  final userBookRepository = UserBookRepository();
  final noteRepository = NoteRepository();
  final readingSessionRepository = ReadingSessionRepository();

  for (var user in users) {
    final newUser = User.fromMap(user, user['id']);
    await userRepository.add(newUser);
    print('User ${user['name']} added to Firestore');
  }

  for (var book in books) {
    final newBook = Book.fromMap(book, book['id']);
    await bookRepository.add(newBook);
    print('Book ${book['title']} added to Firestore');
  }

  for (var userBook in userBooks) {
    final newUserBook = UserBook.fromMap(userBook, userBook['id']);
    await userBookRepository.add(newUserBook);
    print(
        'UserBook ${newUserBook.userId}(userId)/${newUserBook.bookId}(bookId) added to Firestore');
  }

  for (var note in notes) {
    note['createdAt'] = Timestamp.fromDate(DateTime.parse(note['createdAt']));
    note['updatedAt'] = Timestamp.fromDate(DateTime.parse(note['updatedAt']));
    final newNote = Note.fromMap(note, note['id']);
    await noteRepository.add(newNote);
    print('Note ${newNote.title} added to Firestore');
  }

  for (var session in readingSessions) {
    session['startTime'] =
        Timestamp.fromDate(DateTime.parse(session['startTime']));
    session['endTime'] = Timestamp.fromDate(DateTime.parse(session['endTime']));
    final newReadingSession = ReadingSession.fromMap(session, session['id']);
    await readingSessionRepository.add(newReadingSession);
    print('ReadingSession ${newReadingSession.id} added to Firestore');
  }
}
