class ReadingSession {
  String id;
  String userBookId;
  DateTime startTime;
  DateTime endTime;
  int startPage;
  int endPage;
  int duration;
  int earnedExp;

  ReadingSession({
    required this.id,
    required this.userBookId,
    required this.startTime,
    required this.endTime,
    required this.startPage,
    required this.endPage,
    required this.duration,
    required this.earnedExp,
  });

  factory ReadingSession.fromMap(Map<String, dynamic> map) {
    return ReadingSession(
      id: map['id'] as String,
      userBookId: map['userBookId'] as String,
      startTime: map['startTime'] as DateTime,
      endTime: map['endTime'] as DateTime,
      startPage: map['startPage'] as int,
      endPage: map['endPage'] as int,
      duration: map['duration'] as int,
      earnedExp: map['earnedExp'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userBookId': userBookId,
      'startTime': startTime,
      'endTime': endTime,
      'startPage': startPage,
      'endPage': endPage,
      'duration': duration,
      'earnedExp': earnedExp,
    };
  }
}