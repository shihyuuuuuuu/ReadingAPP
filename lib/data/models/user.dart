import 'base.dart';

class User extends MappableModel {
  String? id;
  String name;
  String? email;
  String? avatarUrl;
  // TODO: add email

  @override
  User({required this.name, this.avatarUrl, this.email});

  @override
  User._({required this.id, required this.name, required this.email, this.avatarUrl});

  @override
  factory User.fromMap(Map<String, dynamic> map, String? id) {
    return User._(
      id: id,
      name: map['name'],
      email: map['email'],
      avatarUrl: map['avatarUrl'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'avatarUrl': avatarUrl,
      'email': email,
    };
  }
}
