class User {
  final String username;
  final String email;
  final int id;

  User( {
    required this.username,
    required this.email,
    required this.id
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json["name"],
      email: json["email"],
      id:json["id"]
    );
  }
}
