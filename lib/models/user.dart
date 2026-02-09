class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final bool isAdmin;
  final DateTime createdAt;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.isAdmin,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      isAdmin: json['isAdmin'],
    

      createdAt: DateTime.parse(json['createdAt']),

    );
  }

  String get fullName => '$firstName $lastName';
}
