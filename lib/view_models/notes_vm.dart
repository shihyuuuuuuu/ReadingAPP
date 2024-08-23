import 'dart:async';
import 'package:flutter/material.dart';
import 'package:reading_app/data/models/note.dart';
import 'package:reading_app/data/repositories/note_repo.dart';

class NotesViewModel with ChangeNotifier {
  final NoteRepository _noteRepository;

  final String userId;
  List<Note> _notes = [];
  List<Note> get notes => _notes;
  StreamSubscription<List<Note>>? _notesSubscription;

  NotesViewModel(
      {required this.userId, NoteRepository? noteRepository})
      : _noteRepository = noteRepository ?? NoteRepository() {
    _notesSubscription =
        _noteRepository.stream(userId).listen((notesData) {
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
    await _noteRepository.add(newNote, userId);
  }

  Future<Note?> getNote(String noteId, String userId) async {
    return await _noteRepository.get(noteId, userId);
  }
}
