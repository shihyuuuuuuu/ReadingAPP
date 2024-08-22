abstract class MappableModel {
  MappableModel();

  // `fromMap` and `toMap` are used for interactions with Firebase.
  factory MappableModel.fromMap(Map<String, dynamic> map, String? id) {
    throw UnimplementedError('fromMap must be implemented');
  }
  Map<String, dynamic> toMap();
}
