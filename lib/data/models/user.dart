import 'package:reading_app/data/local/login_method.dart';

import 'base.dart';


class User extends MappableModel {
  String id;
  String name;
  String? email;
  String? avatarUrl;
  late final List<LogInMethod> logInMethods;

User({
    required this.id,
    required this.email,
    required this.name,
    required this.avatarUrl,
    logInMethods,
  }) :logInMethods = logInMethods;
  
  
  @override
  User._({
    required this.id,
    required this.email,
    required this.name,
    required this.avatarUrl,
    logInMethods,
  })  : logInMethods = logInMethods ?? [];

  @override
  factory User.fromMap(Map<String, dynamic> map, String id) {
    return User._(
      id: id,
      name: map['name'],
      email: map['email'],
      avatarUrl: map['avatarUrl'],
      logInMethods: (map['logInMethods'] as List<dynamic>)
          .map((logInMethod) => LogInMethod.values.byName(logInMethod))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'avatarUrl': avatarUrl,
      'email': email,
      'logInMethods':
          logInMethods.map((logInMethod) => logInMethod.name).toList(),
    };
  }
}
