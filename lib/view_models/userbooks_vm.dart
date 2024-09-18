import 'dart:async';
import 'package:flutter/material.dart';
import 'package:reading_app/data/models/user_book.dart';
import 'package:reading_app/data/repositories/user_book_repo.dart';

class UserBooksViewModel with ChangeNotifier {
  final UserBookRepository _userBookRepository;

  final String userId;
  List<UserBook> _userBooks = [];
  List<UserBook> get userBooks => _userBooks;
  StreamSubscription<List<UserBook>>? _userBooksSubscription;

  UserBooksViewModel(
      {required this.userId, UserBookRepository? userBookRepository})
      : _userBookRepository = userBookRepository ?? UserBookRepository() {
    _userBooksSubscription =
        _userBookRepository.stream(userId).listen((userBooksData) {
      _userBooks = userBooksData;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _userBooksSubscription?.cancel();
    super.dispose();
  }

  Future<void> addUserBook(UserBook newUserBook) async {
    await _userBookRepository.add(newUserBook, userId);
  }

  Future<UserBook?> getUserBook(String userBookId) async {
    return await _userBookRepository.get(userBookId, userId);
  }
}
