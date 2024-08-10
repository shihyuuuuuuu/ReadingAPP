import 'package:reading_app/data/models/reading_session.dart';
import 'base_repo.dart';

class ReadingSessionRepository extends BaseRepository<ReadingSession> {
  @override
  ReadingSession fromMap(Map<String, dynamic> map, String id) {
    return ReadingSession.fromMap(map, id);
  }
}
