import 'note_type.dart';

class Note {
  String id;
  String userId;
  String userBookId;
  String readingSessionId;
  String title;
  NoteType type;
  String content;
  int startPage;
  int endPage;
  DateTime createdAt;
  DateTime updatedAt;

  Note({
    required this.id,
    required this.userId,
    required this.userBookId,
    required this.readingSessionId,
    required this.title,
    required this.type,
    required this.content,
    required this.startPage,
    required this.endPage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as String,
      userId: map['userId'] as String,
      userBookId: map['userBookId'] as String,
      readingSessionId: map['readingSessionId'] as String,
      title: map['title'] as String,
      type: map['type'] as String,
      content: map['content'] as String,
      startPage: map['startPage'] as int,
      endPage: map['endPage'] as int,
      createdAt: map['createdAt'] as DateTime,
      updatedAt: map['updatedAt'] as DateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userBookId': userBookId,
      'readingSessionId': readingSessionId,
      'title': title,
      'type': type,
      'content': content,
      'startPage': startPage,
      'endPage': endPage,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}