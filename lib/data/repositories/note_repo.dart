import 'package:reading_app/data/models/note.dart';
import 'base_repo.dart';

class NoteRepository extends BaseRepository<Note> {
  @override
  Note fromMap(Map<String, dynamic> map, String id) {
    return Note.fromMap(map, id);
  }

  @override
  String? parentCollection = 'User';
}
