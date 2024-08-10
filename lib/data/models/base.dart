abstract class MappableModel {
  MappableModel();
  MappableModel._();
  factory MappableModel.fromMap(Map<String, dynamic> map, String id) {
    throw UnimplementedError('fromMap must be implemented');
  }
  Map<String, dynamic> toMap();
}
