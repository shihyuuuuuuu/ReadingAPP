import 'dart:async';
import 'package:flutter/material.dart';
import 'package:reading_app/data/models/note.dart';
import 'package:reading_app/data/repositories/note_repo.dart';

class NotesViewModel with ChangeNotifier {
  final NoteRepository _NoteRepository;

  final String userId;
  List<Note> _notes = [];
  List<Note> get notes => _notes;
  StreamSubscription<List<Note>>? _notesSubscription;

  NotesViewModel(
      {required this.userId, NoteRepository? noteRepository})
      : _NoteRepository = noteRepository ?? NoteRepository() {
    _notesSubscription =
        _NoteRepository.stream(userId).listen((notesData) {
      _notes = notesData;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _notesSubscription?.cancel();
    super.dispose();
  }

  Future<void> addNote(Note newNote, String userId) async {
    await _NoteRepository.add(newNote, userId);
  }

  Future<Note?> getNote(String userBookId, String userId) async {
    return await _NoteRepository.get(userBookId, userId);
  }
}
