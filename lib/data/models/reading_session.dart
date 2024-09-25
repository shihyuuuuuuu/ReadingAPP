import 'package:cloud_firestore/cloud_firestore.dart';
import 'base.dart';

class ReadingSession extends MappableModel {
  String? id;
  String userBookId;
  Timestamp startTime;
  Timestamp endTime;
  int? startPage;
  int? endPage;
  int duration;
  int earnedExp;

  @override
  ReadingSession({
    required this.userBookId,
    required this.startTime,
    required this.endTime,
    this.startPage,
    this.endPage,
    required this.duration,
    required this.earnedExp,
  });

  @override
  ReadingSession._({
    required this.id,
    required this.userBookId,
    required this.startTime,
    required this.endTime,
    this.startPage,
    this.endPage,
    required this.duration,
    required this.earnedExp,
  });

  @override
  factory ReadingSession.fromMap(Map<String, dynamic> map, String? id) {
    return ReadingSession._(
      id: id,
      userBookId: map['userBookId'],
      startTime: map['startTime'],
      endTime: map['endTime'],
      startPage: map['startPage'],
      endPage: map['endPage'],
      duration: map['duration'],
      earnedExp: map['earnedExp'],
    );
  }

  @override
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
