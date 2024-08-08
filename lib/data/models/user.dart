class User {
  String? id;
  String name;
  String? avatarUrl;

  User({required this.name, this.avatarUrl});
  User._({required this.id, required this.name, this.avatarUrl});

  factory User.fromMap(Map<String, dynamic> map, String? id) {
    return User._(
      id: id,
      name: map['name'] as String,
      avatarUrl: map['avatarUrl'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'avatarUrl': avatarUrl,
    };
  }
}
