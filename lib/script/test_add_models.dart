import 'dart:convert';
import 'dart:io';

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
  final userBookRepository = NoteRepository();
  final noteRepository = NoteRepository();
  final readingSessionRepository = ReadingSessionRepository();

  List<String> userIds = [];
  List<Book> bookObjs = [];
  List<String> userBookIds = [];

  for (var user in users) {
    final User newUser = User.fromMap(user, user['id']);
    String id = await userRepository.add(newUser);
    userIds.add(id);
    print('User ${user['name']} $id added to Firestore');
  }

  for (var book in books) {
    book['publishedDate'] =
        Timestamp.fromDate(DateTime.parse(book['publishedDate']));
    final Book newBook = Book.fromMap(book, book['id']);
    newBook.id = await bookRepository.add(newBook);
    bookObjs.add(newBook);
    print('Book ${book['title']} $newBook.id added to Firestore');
  }

  for (final (index, userBook) in userBooks.indexed) {
    userBook['userId'] = userIds[0];
    userBook['book'] = bookObjs[index].toMap();
    userBook['startDate'] =
        Timestamp.fromDate(DateTime.parse(userBook['startDate']));
    final Note newUserBook = Note.fromMap(userBook, userBook['id']);
    String id = await userBookRepository.add(newUserBook, userIds[0]);
    userBookIds.add(id);
    print('UserBook $id added to Firestore');
  }

  userBookIds = userBookIds + userBookIds;

  for (var (index, note) in notes.indexed) {
    note['createdAt'] = Timestamp.fromDate(DateTime.parse(note['createdAt']));
    note['updatedAt'] = Timestamp.fromDate(DateTime.parse(note['updatedAt']));
    note['userId'] = userIds[0];
    note['userBookId'] = userBookIds[index];
    final Note newNote = Note.fromMap(note, note['id']);
    String id = await noteRepository.add(newNote, userIds[0]);
    print('Note ${newNote.title} $id added to Firestore');
  }

  for (var (index, session) in readingSessions.indexed) {
    session['startTime'] =
        Timestamp.fromDate(DateTime.parse(session['startTime']));
    session['endTime'] = Timestamp.fromDate(DateTime.parse(session['endTime']));
    session['userBookId'] = userBookIds[index];
    final ReadingSession newReadingSession =
        ReadingSession.fromMap(session, session['id']);
    String id =
        await readingSessionRepository.add(newReadingSession, userIds[0]);
    print('ReadingSession ${newReadingSession.id} $id added to Firestore');
  }

  exit(0);
}
