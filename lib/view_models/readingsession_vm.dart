import 'dart:async';
import 'package:flutter/material.dart';
import 'package:reading_app/data/models/reading_session.dart';
import 'package:reading_app/data/repositories/reading_session_repo.dart';

class ReadingSessionViewModel with ChangeNotifier {
  final ReadingSessionRepository _readingSessionRepository;

  final String userId;
  List<ReadingSession> _readingSessions = [];
  List<ReadingSession> get readingSessions => _readingSessions;
  StreamSubscription<List<ReadingSession>>? _readingSessionsSubscription;

  ReadingSessionViewModel({
    required this.userId,
    ReadingSessionRepository? readingSessionRepository,
  }) : _readingSessionRepository =
            readingSessionRepository ?? ReadingSessionRepository() {
    _readingSessionsSubscription =
        _readingSessionRepository.stream(userId).listen((readingSessionsData) {
      _readingSessions = readingSessionsData;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _readingSessionsSubscription?.cancel();
    super.dispose();
  }

  Future<void> addReadingSession(ReadingSession newReadingSession) async {
    await _readingSessionRepository.add(newReadingSession, userId);
  }

  Future<ReadingSession?> getReadingSession(String sessionId) async {
    return await _readingSessionRepository.get(sessionId, userId);
  }
}
