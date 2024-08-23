import 'package:cloud_firestore/cloud_firestore.dart';
import '../local/note_type.dart';
import 'base.dart';

class Note extends MappableModel {
  String? id;
  // String userId;
  String userBookId;
  String? readingSessionId;
  String title;
  NoteType type;
  String content;
  int? startPage;
  int? endPage;
  Timestamp createdAt;
  Timestamp updatedAt;

  @override
  Note({
    // required this.userId,
    required this.userBookId,
    this.readingSessionId,
    required this.title,
    required this.type,
    required this.content,
    this.startPage,
    this.endPage,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  })  : createdAt = createdAt ?? Timestamp.now(),
        updatedAt = updatedAt ?? Timestamp.now();

  @override
  Note._({
    required this.id,
    // required this.userId,
    required this.userBookId,
    this.readingSessionId,
    required this.title,
    required this.type,
    required this.content,
    this.startPage,
    this.endPage,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  factory Note.fromMap(Map<String, dynamic> map, String? id) {
    return Note._(
      id: id,
      // userId: map['userId'],
      userBookId: map['userBookId'],
      readingSessionId: map['readingSessionId'],
      title: map['title'],
      type: NoteType.values.byName(map['type']),
      content: map['content'],
      startPage: map['startPage'],
      endPage: map['endPage'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      // 'userId': userId,
      'userBookId': userBookId,
      'readingSessionId': readingSessionId,
      'title': title,
      'type': type.name,
      'content': content,
      'startPage': startPage,
      'endPage': endPage,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
