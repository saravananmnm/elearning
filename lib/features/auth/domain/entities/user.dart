class User {
  final String id;
  final String email;
  final String name;
  final String? token;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.token,
  });

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? token,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      token: token ?? this.token,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'token': token,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          name == other.name &&
          token == other.token;

  @override
  int get hashCode =>
      id.hashCode ^ email.hashCode ^ name.hashCode ^ (token?.hashCode ?? 0);
}
