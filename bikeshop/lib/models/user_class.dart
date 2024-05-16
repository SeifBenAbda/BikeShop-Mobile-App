class Users {
  final String id;
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  final String avatarUrl;
  final String email;
  final String credits;
  final bool isClient;
  final DateTime createdAt;
  final DateTime updatedAt;

  Users({
    required this.id,
    required this.updatedAt,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.avatarUrl,
    required this.email,
    required this.credits,
    required this.isClient,
    required this.createdAt,
  });
}

